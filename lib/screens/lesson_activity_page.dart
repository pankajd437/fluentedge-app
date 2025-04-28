import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
// REMOVED: import 'package:reorderables/reorderables.dart'; // No longer needed

import 'package:fluentedge_app/constants.dart'; // Make sure your color/style constants exist here
import 'package:fluentedge_app/widgets/animated_mentor_widget.dart';
import 'package:fluentedge_app/widgets/quiz_activity_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:fluentedge_app/data/user_state.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/foundation.dart' show listEquals;

//
// ------------------ GLOW SHADOWS & REUSABLE CONTAINERS ------------------
//

// Example "glow" box shadows. Tweak or move them to constants.dart if you like.
final BoxShadow kGlowBoxShadowPink = BoxShadow(
  color: Colors.pinkAccent.withOpacity(0.6),
  blurRadius: 12,
  spreadRadius: 2,
  offset: const Offset(0, 0),
);

final BoxShadow kGlowBoxShadowBlue = BoxShadow(
  color: Colors.blueAccent.withOpacity(0.5),
  blurRadius: 12,
  spreadRadius: 2,
  offset: const Offset(0, 0),
);

final BoxShadow kGlowBoxShadowGreen = BoxShadow(
  color: Colors.greenAccent.withOpacity(0.5),
  blurRadius: 12,
  spreadRadius: 2,
  offset: const Offset(0, 0),
);

/// Reusable container for gradient backgrounds + optional glow
Widget buildGlowingContainer({
  Key? key,
  required Widget child,
  required List<Color> gradientColors,
  required List<BoxShadow> shadows,
}) {
  return Container(
    key: key,
    margin: const EdgeInsets.symmetric(vertical: 10),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: gradientColors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(20),
      boxShadow: shadows,
    ),
    child: child,
  );
}

//
// ---------- EXISTING FONT & STYLE CONSTANTS (REFERENCED FROM constants.dart) ----------
//
// e.g. kActivityBodyStyle, kBaseFontSize, kVibrantMessageStyle, kVibrantTitleStyle, etc.
// Make sure they're defined in `constants.dart` and imported above.
//

String get userName => UserState.instance.userName ?? 'Friend';

Widget buildTextWithUserName(String? rawText, {TextAlign align = TextAlign.center}) {
  if (rawText == null || rawText.trim().isEmpty) {
    return const Text('...');
  }
  final parts = rawText.split('[Your Name]');
  return DefaultTextStyle(
    style: const TextStyle(fontSize: kBaseFontSize, fontWeight: FontWeight.w500, color: Colors.white),
    child: RichText(
      textAlign: align,
      text: TextSpan(
        children: [
          TextSpan(text: parts.isNotEmpty ? parts[0] : ''),
          if (parts.length > 1)
            TextSpan(
              text: userName,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          if (parts.length > 1) TextSpan(text: parts[1]),
        ],
      ),
    ),
  );
}

class LessonActivityPage extends StatefulWidget {
  final String lessonJsonPath;
  final String lessonTitle;

  const LessonActivityPage({
    Key? key,
    required this.lessonJsonPath,
    required this.lessonTitle,
  }) : super(key: key);

  @override
  State<LessonActivityPage> createState() => _LessonActivityPageState();
}

class _LessonActivityPageState extends State<LessonActivityPage> with SingleTickerProviderStateMixin {
  final List<bool> _quizResults = [];
  String _expressionName = 'mentor_thinking_upper.png';
  bool _quizFailed = false;

  List<dynamic> _activities = [];
  int _currentActivityIndex = 0;
  bool _loading = true;
  bool _loadError = false;

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _autoPlayDoneForThisActivity = false;
  bool _autoAdvanceTriggered = false;

  String _lessonId = '';
  String _lessonThemeColorHex = '';
  int _xpTotal = 0;
  Map<String, dynamic>? _badgeAwarded;

  // Mentor animation
  late AnimationController _mentorAnimController;
  late Animation<double> _mentorScaleAnim;
  late Animation<double> _mentorFadeAnim;

  @override
  void initState() {
    super.initState();
    _loadLessonJson();

    // Setup animation for mentor widget
    _mentorAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _mentorScaleAnim = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _mentorAnimController, curve: Curves.easeOutBack),
    );
    _mentorFadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _mentorAnimController, curve: Curves.easeIn),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mentorAnimController.forward();
    });
  }

  @override
  void dispose() {
    _mentorAnimController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _loadLessonJson() async {
    try {
      final String content = await rootBundle.loadString(widget.lessonJsonPath);
      final data = jsonDecode(content);

      _lessonId = data['lessonId'] ?? '';
      _lessonThemeColorHex = data['themeColor'] ?? '';
      _xpTotal = data['xpTotal'] ?? 0;
      _badgeAwarded = data['badgeAwarded'];

      setState(() {
        _activities = data['activities'] ?? [];
        _loading = false;
        _loadError = false;
      });
    } catch (e) {
      debugPrint('❌ JSON Load Failed: $e');
      setState(() {
        _activities = [];
        _loadError = true;
        _loading = false;
      });
    }
  }

  void _handleAnswerSelected(bool isCorrect) {
    _quizResults.add(isCorrect);
    if (!isCorrect) {
      setState(() {
        _quizFailed = true;
        _expressionName = 'mentor_confused_upper.png';
      });
    } else {
      setState(() {
        _expressionName = 'mentor_celebrate_full.png';
      });
    }
    if (isCorrect && !_autoAdvanceTriggered) {
      _autoAdvanceTriggered = true;
      Future.delayed(const Duration(seconds: 1), () {
        _handleActivityCompleted();
        setState(() {
          _expressionName = 'mentor_thinking_upper.png';
          _autoAdvanceTriggered = false;
        });
      });
    }
  }

  void _retryQuiz() {
    setState(() {
      _quizFailed = false;
      _expressionName = 'mentor_encouraging_upper.png';
    });
  }

  void _handleActivityCompleted() {
    if (_currentActivityIndex < _activities.length - 1) {
      setState(() {
        _currentActivityIndex++;
        _autoPlayDoneForThisActivity = false;
        _expressionName = 'mentor_thinking_upper.png';
        _quizFailed = false;
      });
    } else {
      final bool allCorrect = _quizResults.isNotEmpty && !_quizResults.contains(false);
      GoRouter.of(context).push('/lessonComplete', extra: {
        'lessonTitle': widget.lessonTitle,
        'lessonId': _lessonId.isNotEmpty ? _lessonId : widget.lessonTitle.replaceAll(' ', '_').toLowerCase(),
        'isCorrect': allCorrect,
        'earnedXP': allCorrect ? kLessonCompletionPoints : 0,
        'badgeId': null,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        final scale = 0.95 + (0.05 * value);
        return Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryBlue,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => context.pop(),
          ),
          title: Text(
            widget.lessonTitle,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF8FBFF), Color(0xFFFFFFFF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Activity ${_currentActivityIndex + 1} of ${_activities.length}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Mentor widget
                  Center(
                    child: ScaleTransition(
                      scale: _mentorScaleAnim,
                      child: FadeTransition(
                        opacity: _mentorFadeAnim,
                        child: AnimatedMentorWidget(
                          size: 120,
                          expressionName: _expressionName,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Current activity
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) {
                      final slideAnimation = Tween<Offset>(
                        begin: const Offset(0.1, 0),
                        end: Offset.zero,
                      ).animate(animation);
                      return SlideTransition(
                        position: slideAnimation,
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      );
                    },
                    child: _buildCurrentActivity(),
                  ),
                  const SizedBox(height: 30),
                  // Prev/Next
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: _currentActivityIndex == 0
                            ? null
                            : () {
                                if (_currentActivityIndex > 0) {
                                  setState(() {
                                    _currentActivityIndex--;
                                    _autoPlayDoneForThisActivity = false;
                                    _expressionName = 'mentor_thinking_upper.png';
                                  });
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          disabledBackgroundColor: Colors.grey.shade300,
                          disabledForegroundColor: Colors.black26,
                          backgroundColor: kPrimaryBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
                        ),
                        child: const Text("Previous", style: TextStyle(fontSize: 18)),
                      ),
                      ElevatedButton(
                        onPressed: _handleActivityCompleted,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
                        ),
                        child: const Text("Next", style: TextStyle(fontSize: 18)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// For inline feedback animations if desired
  void _showFeedbackAnimation(bool isCorrect) {
    final overlay = Overlay.of(context);
    if (overlay == null) return;

    final overlayEntry = OverlayEntry(
      builder: (_) => Center(
        child: SizedBox(
          width: 180,
          height: 180,
          child: Lottie.asset(
            isCorrect
                ? 'assets/animations/activity_correct.json'
                : 'assets/animations/activity_wrong.json',
            repeat: false,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2), () => overlayEntry.remove());
  }

  Future<void> _playActivitySound({
    required bool isCorrect,
    String? correctSoundPath,
    String? wrongSoundPath,
  }) async {
    try {
      await _audioPlayer.stop();
      String chosenPath;
      if (isCorrect) {
        chosenPath = correctSoundPath ?? 'assets/sounds/correct.mp3';
      } else {
        chosenPath = wrongSoundPath ?? 'assets/sounds/incorrect.mp3';
      }
      final finalPath = chosenPath.replaceFirst('assets/', '');
      await _audioPlayer.play(AssetSource(finalPath));
    } catch (e) {
      debugPrint("❌ Sound error: $e");
    }
  }

  Widget _buildCurrentActivity() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(key: ValueKey("loading")));
    }
    if (_loadError) {
      return Column(
        key: const ValueKey("error"),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/animations/ai_mentor_thinking.json',
            height: 120,
            repeat: true,
          ),
          const SizedBox(height: 20),
          Text(
            "⚠️ This lesson’s content could not be loaded.",
            style: kActivityBodyStyle.copyWith(color: Colors.redAccent, fontSize: 18),
          ),
        ],
      );
    }
    if (_activities.isEmpty) {
      return Center(
        key: const ValueKey("empty"),
        child: Text(
          "⚠️ No activities found for this lesson.",
          style: kActivityBodyStyle.copyWith(fontSize: 18),
        ),
      );
    }

    final current = _activities[_currentActivityIndex];
    final String rawType = current['type'] as String? ?? '';
    final String normalizedType = _normalizeActivityType(rawType);

    // Possibly override mentor expression if not in quiz fail state
    if (!_autoAdvanceTriggered && !_quizFailed) {
      final customExpr = current['expression'] as String?;
      _expressionName = customExpr ?? _getExpressionForActivity(normalizedType);
    }

    switch (normalizedType) {
      case 'mentor_intro':
        return _buildMentorIntro(current);
      case 'mentor_explain':
        return _buildMentorExplain(current);
      case 'quiz':
        return _buildQuiz(current);
      case 'audio_clip':
        return _buildAudioClip(current);
      case 'scene_image':
        return _buildSceneImage(current);
      case 'text_card':
        return _buildTextCard(current);
      case 'speaking_prompt':
        return _buildSpeakingPrompt(current);
      case 'real_life_simulation':
        return _buildRealLifeSimulation(current);
      case 'mentor_surprise_fact':
        return _buildMentorSurpriseFact(current);
      case 'badge_award':
        return _buildBadgeAward(current);
      case 'recap_card':
        return _buildRecapCard(current);
      case 'next_lesson_preview':
        return _buildNextLessonPreview(current);

      // Newly handled or advanced
      case 'dialogue_reconstruction':
        return _buildDialogueReconstruction(current);
      case 'fill_in_the_blanks':
        return _buildFillInTheBlanks(current);
      case 'sentence_construction':
        return _buildSentenceConstruction(current);
      case 'today_vocabulary':
        return _buildTodayVocabulary(current);
      case 'word_builder':
        return _buildWordBuilder(current);
      case 'mini_stories':
        return _buildMiniStories(current);

      // UPDATED spot_the_error
      case 'spot_the_error':
        return _buildSpotTheError(current);

      default:
        return Text(
          "🚧 Unsupported activity type: $normalizedType",
          style: kActivityBodyStyle.copyWith(fontWeight: FontWeight.w600, fontSize: 18),
          key: const ValueKey("unsupported"),
        );
    }
  }

  /// For backward-compat with older JSON references
  String _normalizeActivityType(String rawType) {
    switch (rawType) {
      case 'auto_audio':
        return 'mentor_intro';
      case 'message':
        return 'mentor_explain';
      case 'audio':
        return 'audio_clip';
      case 'image':
        return 'scene_image';
      case 'text':
      case 'text_display':
        return 'text_card';
      case 'poll':
      case 'tip':
        return 'mentor_surprise_fact';
      case 'roleplay':
        return 'real_life_simulation';
      case 'badge':
        return 'badge_award';
      default:
        return rawType;
    }
  }

  /// Decide mentor PNG for each activity type
  String _getExpressionForActivity(String type) {
    switch (type) {
      case 'mentor_intro':
        return 'mentor_wave_smile_full.png';
      case 'mentor_explain':
        return 'mentor_tip_upper.png';
      case 'quiz':
        return 'mentor_analytical_upper.png';
      case 'audio_clip':
        return 'mentor_audio_ready_upper.png';
      case 'scene_image':
        return 'mentor_curious_upper.png';
      case 'text_card':
        return 'mentor_thinking_upper.png';
      case 'speaking_prompt':
        return 'mentor_audio_ready_upper.png';
      case 'real_life_simulation':
        return 'mentor_encouraging_upper.png';
      case 'mentor_surprise_fact':
        return 'mentor_surprised_upper.png';
      case 'badge_award':
        return 'mentor_proud_full.png';
      case 'recap_card':
        return 'mentor_tip_upper.png';
      case 'next_lesson_preview':
        return 'mentor_thumbs_up_full.png';

      // new
      case 'dialogue_reconstruction':
        return 'mentor_curious_upper.png';
      case 'fill_in_the_blanks':
        return 'mentor_thinking_upper.png';
      case 'sentence_construction':
      case 'word_builder':
        return 'mentor_analytical_upper.png';
      case 'today_vocabulary':
        return 'mentor_encouraging_upper.png';
      case 'mini_stories':
        return 'mentor_silly_upper.png';
      case 'spot_the_error':
        return 'mentor_confused_upper.png';

      default:
        return 'mentor_thinking_upper.png';
    }
  }

  //
  // --------------------------------
  // ACTIVITY BUILDERS
  // --------------------------------

  // 1) MENTOR INTRO (ADDED optional image display)
  Widget _buildMentorIntro(Map<String, dynamic> activity) {
    final imagePath = activity['imagePath']?.toString() ?? '';
    final audioPath = activity['audioPath']?.toString() ?? '';
    final text = activity['text']?.toString() ?? '';
    final allowPause = activity['allowPause'] == true;

    if (!_autoPlayDoneForThisActivity && audioPath.isNotEmpty) {
      _autoPlayDoneForThisActivity = true;
      Future.microtask(() async {
        try {
          await _audioPlayer.stop();
          final relative = audioPath.replaceFirst('assets/', '');
          await _audioPlayer.play(AssetSource(relative));
        } catch (e) {
          debugPrint("❌ [mentor_intro] auto audio fail: $e");
        }
      });
    }

    final List<Color> introGradient = [
      const Color(0xFF8E24AA),
      const Color(0xFF7B1FA2),
    ];

    return buildGlowingContainer(
      key: const ValueKey("mentor_intro"),
      gradientColors: introGradient,
      shadows: [kGlowBoxShadowPink],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imagePath.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 150,
                  color: Colors.grey.shade200,
                  alignment: Alignment.center,
                  child: const Text('Image not found', style: TextStyle(color: Colors.grey)),
                ),
              ),
            ),
          const SizedBox(height: 10),
          if (text.trim().isNotEmpty)
            Text(
              text,
              style: kVibrantMessageStyle.copyWith(fontSize: kBaseFontSize + 2),
            ),
          const SizedBox(height: 10),
          if (allowPause)
            ElevatedButton.icon(
              onPressed: () async {
                await _audioPlayer.stop();
              },
              icon: const Icon(Icons.stop),
              label: const Text("Stop"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // 2) MENTOR EXPLAIN ...
  Widget _buildMentorExplain(Map<String, dynamic> current) {
    final text = current['text']?.toString() ?? '';

    return buildGlowingContainer(
      key: const ValueKey("mentor_explain"),
      gradientColors: [vibrantPink.withOpacity(0.95), vibrantPink],
      shadows: [kGlowBoxShadowPink],
      child: AnimatedTextKit(
        isRepeatingAnimation: false,
        animatedTexts: [
          TypewriterAnimatedText(
            text,
            textStyle: kVibrantMessageStyle.copyWith(fontSize: kBaseFontSize + 2),
            speed: const Duration(milliseconds: 40),
            cursor: '▌',
          ),
        ],
      ),
    );
  }

  // 3) QUIZ ...
  Widget _buildQuiz(Map<String, dynamic> current) {
    final rawHints = current['hints'];
    List<String>? hints;
    if (rawHints is List) {
      hints = rawHints.whereType<String>().toList();
    }
    final allowRetry = current['allowRetry'] == true;
    final encouragementOnFail = current['encouragementOnFail']?.toString();

    return Column(
      key: const ValueKey("quiz"),
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [kGlowBoxShadowGreen],
          ),
          child: QuizActivityWidget(
            question: current['question'],
            options: List<String>.from(current['options']),
            correctIndex: current['answerIndex'],
            onAnswerSelected: _handleAnswerSelected,
            onCompleted: () {},
            correctSound: current['correctSound'],
            wrongSound: current['wrongSound'],
            hints: hints,
            allowRetry: allowRetry,
            encouragementOnFail: encouragementOnFail,
          ),
        ),
        if (allowRetry && _quizFailed)
          ElevatedButton.icon(
            onPressed: _retryQuiz,
            icon: const Icon(Icons.refresh),
            label: const Text("Try Again", style: TextStyle(fontSize: 18)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              elevation: 5,
            ),
          ),
      ],
    );
  }

  // 4) AUDIO CLIP ...
  Widget _buildAudioClip(Map<String, dynamic> current) {
    final audioPath = current['audioPath']?.toString() ?? '';
    final caption = current['caption']?.toString() ?? '';

    final List<Color> audioGradient = [
      const Color(0xFF4DB6AC),
      const Color(0xFF80CBC4),
    ];

    return buildGlowingContainer(
      key: const ValueKey("audio_clip"),
      gradientColors: audioGradient,
      shadows: [kGlowBoxShadowBlue],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (caption.isNotEmpty)
            Text(
              caption,
              style: kAudioInstructionStyle.copyWith(fontSize: kBaseFontSize + 4),
            ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () async {
              await _audioPlayer.stop();
              if (audioPath.trim().isNotEmpty) {
                final relative = audioPath.replaceFirst('assets/', '');
                await _audioPlayer.play(AssetSource(relative));
              }
            },
            icon: const Icon(Icons.volume_up, size: 24),
            label: const Text("Play Audio", style: TextStyle(fontSize: 18)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00796B),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              elevation: 5,
            ),
          ),
        ],
      ),
    );
  }

  // 5) SCENE IMAGE ...
  Widget _buildSceneImage(Map<String, dynamic> current) {
    final caption = current['caption']?.toString() ?? '';
    final path = current['imagePath']?.toString() ?? '';

    return buildGlowingContainer(
      key: const ValueKey("scene_image"),
      gradientColors: [vibrantPink.withOpacity(0.95), vibrantPink],
      shadows: [kGlowBoxShadowPink],
      child: Column(
        children: [
          if (caption.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                caption,
                style: kVibrantCaptionStyle.copyWith(fontSize: kBaseFontSize),
                textAlign: TextAlign.center,
              ),
            ),
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              path,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 150,
                color: Colors.grey.shade200,
                alignment: Alignment.center,
                child: const Text(
                  'Image not found',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 6) TEXT CARD ...
  Widget _buildTextCard(Map<String, dynamic> current) {
    final title = current['title']?.toString() ?? '';
    final body = current['body']?.toString() ?? current['content']?.toString() ?? '';

    final List<Color> welcomeCardGradient = [
      const Color(0xFF283593),
      const Color(0xFF3F51B5),
    ];

    return buildGlowingContainer(
      key: const ValueKey("text_card"),
      gradientColors: welcomeCardGradient,
      shadows: [kGlowBoxShadowBlue],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            Text(
              title,
              style: kVibrantTitleStyle.copyWith(fontSize: kBaseFontSize + 4),
            ),
          const SizedBox(height: 6),
          Text(
            body,
            style: kVibrantBodyStyle.copyWith(fontSize: kBaseFontSize + 3),
          ),
        ],
      ),
    );
  }

  // 7) SPEAKING PROMPT
  Widget _buildSpeakingPrompt(Map<String, dynamic> current) {
    final prompt = current['prompt']?.toString() ?? '';
    final audioPath = current['audioPath']?.toString() ?? '';
    final audioSupport = current['audioSupport'] == true;

    final List<Color> speakingPromptGradient = [
      const Color(0xFF4A148C),
      const Color(0xFF7B1FA2),
    ];

    return buildGlowingContainer(
      key: const ValueKey("speaking_prompt"),
      gradientColors: speakingPromptGradient,
      shadows: [kGlowBoxShadowPink],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "🗣️ Try Saying This:",
            style: kSpeakingPromptTitleStyleNew.copyWith(fontSize: kBaseFontSize + 2),
          ),
          const SizedBox(height: 8),
          DefaultTextStyle(
            style: const TextStyle(fontSize: 28, color: Colors.white),
            child: buildTextWithUserName(prompt, align: TextAlign.start),
          ),
          if (audioSupport) ...[
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                await _audioPlayer.stop();
                if (audioPath.trim().isNotEmpty) {
                  final relative = audioPath.replaceFirst('assets/', '');
                  await _audioPlayer.play(AssetSource(relative));
                }
              },
              icon: const Icon(Icons.mic, size: 24),
              label: const Text("Listen to Example", style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF311B92),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                elevation: 5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // 8) REAL LIFE SIMULATION ...
  Widget _buildRealLifeSimulation(Map<String, dynamic> current) {
    final text = current['text']?.toString() ?? '';

    return buildGlowingContainer(
      key: const ValueKey("real_life_simulation"),
      gradientColors: [refinedGreenStart.withOpacity(0.95), refinedGreenEnd],
      shadows: [kGlowBoxShadowGreen],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "🤝 Role-Play Time!",
            style: kVibrantTitleStyle.copyWith(fontSize: kBaseFontSize + 4),
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: kVibrantBodyStyle.copyWith(fontSize: kBaseFontSize + 2),
          ),
        ],
      ),
    );
  }

  // 9) MENTOR SURPRISE FACT or POLL ...
  Widget _buildMentorSurpriseFact(Map<String, dynamic> current) {
    final title = current['title']?.toString();
    final body = current['body']?.toString();
    final question = current['question']?.toString();
    final List<String>? options = (current['options'] as List?)?.cast<String>();

    final dynamicFeedback = current['dynamicFeedback'] as Map<String, dynamic>?;

    final List<Color> surpriseFactGradient = [
      const Color(0xFF6A1B9A),
      const Color(0xFF4A148C),
    ];

    // It's a poll scenario
    if (question != null && options != null && options.isNotEmpty) {
      return buildGlowingContainer(
        key: const ValueKey("mentor_surprise_fact_poll"),
        gradientColors: surpriseFactGradient,
        shadows: [kGlowBoxShadowPink],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: kVibrantTitleStyle.copyWith(fontSize: kBaseFontSize + 3),
            ),
            const SizedBox(height: 12),
            ...options.asMap().entries.map((entry) {
              final index = entry.key;
              final optionText = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: ElevatedButton(
                  onPressed: () {
                    if (dynamicFeedback != null && dynamicFeedback.containsKey(index.toString())) {
                      final feedbackMsg = dynamicFeedback[index.toString()];
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Poll Feedback"),
                          content: Text(
                            feedbackMsg.toString(),
                            style: const TextStyle(fontSize: 18),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _handleActivityCompleted();
                              },
                              child: const Text("OK"),
                            )
                          ],
                        ),
                      );
                    } else {
                      _handleActivityCompleted();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                  child: Text(optionText, style: const TextStyle(fontSize: 18)),
                ),
              );
            }).toList()
          ],
        ),
      );
    }
    // simple tip/fact
    else if (title != null && body != null) {
      return buildGlowingContainer(
        key: const ValueKey("mentor_surprise_fact_text"),
        gradientColors: surpriseFactGradient,
        shadows: [kGlowBoxShadowPink],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: kVibrantTitleStyle.copyWith(fontSize: kBaseFontSize + 3),
            ),
            const SizedBox(height: 12),
            Text(
              body,
              style: kVibrantBodyStyle.copyWith(fontSize: kBaseFontSize + 2),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  // 10) BADGE AWARD ...
  Widget _buildBadgeAward(Map<String, dynamic> current) {
    final title = current['title']?.toString() ?? '';
    final description = current['description']?.toString() ?? '';
    final animation = current['animation']?.toString();

    return buildGlowingContainer(
      key: const ValueKey("badge_award"),
      gradientColors: [vibrantPink.withOpacity(0.95), vibrantPink],
      shadows: [kGlowBoxShadowPink],
      child: Column(
        children: [
          if (animation != null && animation.trim().isNotEmpty)
            Lottie.asset(
              animation,
              repeat: false,
              height: 180,
              fit: BoxFit.contain,
            ),
          const SizedBox(height: 10),
          Text(
            title,
            style: kVibrantTitleStyle.copyWith(fontSize: kBaseFontSize + 4),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: kVibrantBodyStyle.copyWith(fontSize: kBaseFontSize + 2),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // 11) RECAP CARD ...
  Widget _buildRecapCard(Map<String, dynamic> current) {
    final summary = current['summary']?.toString() ?? 'No recap info available.';

    return buildGlowingContainer(
      key: const ValueKey("recap_card"),
      gradientColors: [Colors.brown, Colors.brown.shade300],
      shadows: [
        BoxShadow(
          color: Colors.brown.withOpacity(0.5),
          blurRadius: 10,
          spreadRadius: 2,
        ),
      ],
      child: Text(
        summary,
        style: kVibrantBodyStyle.copyWith(fontSize: kBaseFontSize + 2),
      ),
    );
  }

  // 12) NEXT LESSON PREVIEW ...
  Widget _buildNextLessonPreview(Map<String, dynamic> current) {
    final title = current['title']?.toString() ?? 'Next Lesson Preview';
    final shortDesc = current['description']?.toString() ?? '';

    return buildGlowingContainer(
      key: const ValueKey("next_lesson_preview"),
      gradientColors: [Colors.blueGrey, Colors.grey],
      shadows: [
        BoxShadow(
          color: Colors.blueGrey.withOpacity(0.5),
          blurRadius: 8,
          spreadRadius: 2,
        ),
      ],
      child: Column(
        children: [
          Text(
            title,
            style: kVibrantTitleStyle.copyWith(fontSize: kBaseFontSize + 3),
          ),
          const SizedBox(height: 6),
          Text(
            shortDesc,
            style: kVibrantBodyStyle.copyWith(fontSize: kBaseFontSize + 2),
          ),
        ],
      ),
    );
  }

  //
  // ---------------- NEW ACTIVITY BUILDERS WITH REQUESTED ENHANCEMENTS ----------------
  //

  // A) DIALOGUE RECONSTRUCTION ...
  Widget _buildDialogueReconstruction(Map<String, dynamic> current) {
    final List<dynamic> messages = current['messages'] ?? [];

    return Container(
      key: const ValueKey("dialogue_reconstruction"),
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE1F5FE), Color(0xFFB3E5FC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [kGlowBoxShadowBlue],
      ),
      child: Column(
        children: [
          const Text(
            "Dialogue Reconstruction",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...messages.map((msg) => _buildChatBubble(msg)).toList(),
        ],
      ),
    );
  }

  /// Enhanced chat bubble with user/friend images
  Widget _buildChatBubble(Map<String, dynamic> msg) {
    final text = msg['text'] as String? ?? '...';
    final bool isSender = msg['isSender'] == true;

    // Overriding or fallback images
    final avatarPath = msg['avatarPath'] ??
        (isSender
            ? 'assets/images/chat_user_pink.png'
            : 'assets/images/chat_friend_blue.png');

    final avatar = CircleAvatar(
      radius: 32,
      backgroundImage: AssetImage(avatarPath),
    );

    final bubble = Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      constraints: const BoxConstraints(maxWidth: 280),
      decoration: BoxDecoration(
        color: isSender ? const Color(0xFFDCF8C6) : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(12),
          topRight: const Radius.circular(12),
          bottomLeft: isSender ? const Radius.circular(12) : const Radius.circular(0),
          bottomRight: isSender ? const Radius.circular(0) : const Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(
            color: (isSender ? Colors.greenAccent : Colors.grey).withOpacity(0.4),
            blurRadius: 6,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(text, style: const TextStyle(fontSize: 16, color: Colors.black87)),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isSender) ...[
            avatar,
            const SizedBox(width: 8),
            bubble,
          ] else ...[
            bubble,
            const SizedBox(width: 8),
            avatar,
          ],
        ],
      ),
    );
  }

  // B) FILL IN THE BLANKS ...
  Widget _buildFillInTheBlanks(Map<String, dynamic> current) {
    final sentence = current['sentence']?.toString() ?? '';
    final correctWord = current['correctWord']?.toString() ?? '';
    final imagePath = current['imagePath']?.toString() ?? '';
    final hints = (current['hints'] as List?)?.cast<String>();
    final correctSound = current['correctSound']?.toString();
    final wrongSound = current['wrongSound']?.toString();
    final correctLottie = current['correctLottie']?.toString();
    final wrongLottie = current['wrongLottie']?.toString();
    final submitLabel = current['submitLabel']?.toString() ?? 'Check Answer';
    final feedbackData = current['feedback'] as Map<String, dynamic>?;

    // We'll store user input here for the button press
    final textController = TextEditingController();

    return Container(
      key: const ValueKey("fill_in_the_blanks"),
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF8E1), Color(0xFFFFECB3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.amberAccent.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imagePath.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Text("Image not found", style: TextStyle(color: Colors.grey)),
              ),
            ),
          const SizedBox(height: 12),
          Text("Fill in the Blank:", style: kActivityBodyStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            sentence,
            style: kActivityBodyStyle.copyWith(fontSize: 18, color: Colors.black87),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: textController,
                  decoration: const InputDecoration(
                    labelText: "Enter missing word",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (hints != null && hints.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.help_outline),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Hint"),
                        content: Text(hints.join("\n\n")),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("OK"),
                          )
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () async {
                final userWord = textController.text.trim().toLowerCase();
                final neededWord = correctWord.toLowerCase();
                final isCorrect = userWord == neededWord;

                // Play sound
                await _playActivitySound(
                  isCorrect: isCorrect,
                  correctSoundPath: correctSound,
                  wrongSoundPath: wrongSound,
                );

                // Show feedback animation
                final overlay = Overlay.of(context);
                if (overlay != null) {
                  final overlayEntry = OverlayEntry(
                    builder: (_) => Center(
                      child: SizedBox(
                        width: 180,
                        height: 180,
                        child: Lottie.asset(
                          isCorrect
                              ? (correctLottie ?? 'assets/animations/activity_correct.json')
                              : (wrongLottie ?? 'assets/animations/activity_wrong.json'),
                          repeat: false,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                  overlay.insert(overlayEntry);
                  Future.delayed(const Duration(seconds: 2), () => overlayEntry.remove());
                }

                if (isCorrect) {
                  setState(() => _expressionName = 'mentor_celebrate_full.png');

                  if (feedbackData != null && feedbackData['correctText'] != null) {
                    _showFillBlankFeedback(feedbackData['correctText'].toString());
                  } else {
                    _showFillBlankFeedback("Great job! '$correctWord' is correct!");
                  }

                  Future.delayed(const Duration(seconds: 1), () {
                    _handleActivityCompleted();
                    setState(() => _expressionName = 'mentor_thinking_upper.png');
                  });
                } else {
                  setState(() => _expressionName = 'mentor_confused_upper.png');

                  if (feedbackData != null && feedbackData['wrongText'] != null) {
                    _showFillBlankFeedback(feedbackData['wrongText'].toString());
                  } else {
                    _showFillBlankFeedback("Almost there! The right answer is '$correctWord'. Try again!");
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text(submitLabel, style: const TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  void _showFillBlankFeedback(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Result"),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))
        ],
      ),
    );
  }

  // C) SENTENCE CONSTRUCTION ...
  Widget _buildSentenceConstruction(Map<String, dynamic> current) {
    final words = (current['words'] as List?)?.cast<String>() ?? [];
    final correctOrder = (current['correctOrder'] as List?)?.cast<String>() ?? [];
    final imagePath = current['imagePath']?.toString() ?? '';

    return _SentenceConstructionWidget(
      words: words,
      correctOrder: correctOrder,
      imagePath: imagePath,
      onActivityCompleted: _handleActivityCompleted,
      onMentorExpressionChange: (expr) {
        setState(() => _expressionName = expr);
      },
    );
  }

  // D) TODAY’S VOCABULARY ...
  Widget _buildTodayVocabulary(Map<String, dynamic> current) {
    final List<dynamic> vocabItems = current['vocabItems'] ?? [];

    return Container(
      key: const ValueKey("today_vocabulary"),
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE1BEE7), Color(0xFFF3E5F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [kGlowBoxShadowPink],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Today's Vocabulary",
              style: kActivityBodyStyle.copyWith(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 10),
          ...vocabItems.map((item) => _buildVocabCard(item)).toList(),
        ],
      ),
    );
  }

  Widget _buildVocabCard(Map<String, dynamic> item) {
    final word = item['word']?.toString() ?? '';
    final meaning = item['meaning']?.toString() ?? '';
    final imagePath = item['image']?.toString();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurpleAccent.withOpacity(0.25),
            blurRadius: 6,
            spreadRadius: 2,
          )
        ],
      ),
      child: ListTile(
        leading: (imagePath != null)
            ? Image.asset(imagePath, width: 48, height: 48, fit: BoxFit.cover, errorBuilder: (_, __, ___) {
                return const Icon(Icons.image_not_supported);
              })
            : null,
        title: Text(word, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(meaning, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  // E) WORD BUILDER ...
  Widget _buildWordBuilder(Map<String, dynamic> current) {
    final letters = (current['letters'] as List?)?.cast<String>() ?? [];
    final correctWord = current['correctWord']?.toString() ?? '';
    final extraLetters = (current['extraLetters'] as List?)?.cast<String>() ?? [];
    final instruction = current['instruction']?.toString() ??
        "(Drag letters to form the correct word, then tap 'Check Word')";

    return _WordBuilderWidget(
      letters: letters,
      extraLetters: extraLetters,
      correctWord: correctWord,
      instruction: instruction,
      onActivityCompleted: _handleActivityCompleted,
      onMentorExpressionChange: (expr) {
        setState(() => _expressionName = expr);
      },
    );
  }

  // F) MINI STORIES ...
  Widget _buildMiniStories(Map<String, dynamic> current) {
    final List<dynamic> scenes = current['scenes'] ?? [];

    return Container(
      key: const ValueKey("mini_stories"),
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.orangeAccent.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Mini-Story", style: kActivityBodyStyle.copyWith(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...scenes.map((scene) => _buildMiniStoryScene(scene)).toList(),
        ],
      ),
    );
  }

  Widget _buildMiniStoryScene(Map<String, dynamic> scene) {
    final imagePath = scene['imagePath']?.toString();
    final text = scene['text']?.toString() ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          if (imagePath != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(imagePath, fit: BoxFit.cover),
            ),
          const SizedBox(height: 8),
          Text(
            text,
            style: kActivityBodyStyle.copyWith(fontSize: 18),
          ),
        ],
      ),
    );
  }

  // G) SPOT THE ERROR - UPDATED FOR MULTIPLE CHOICES
  Widget _buildSpotTheError(Map<String, dynamic> current) {
    final originalSentence = current['originalSentence']?.toString() ?? '';
    final explanation = current['explanation']?.toString() ?? '';
    final imagePath = current['imagePath']?.toString();

    final List<String>? choices = (current['choices'] as List?)?.cast<String>();
    final int? correctIndex = current['correctChoiceIndex'] as int?;
    final correctSound = current['correctSound']?.toString();
    final wrongSound = current['wrongSound']?.toString();

    // If no 'choices' or 'correctIndex' exist, fallback to old approach
    if (choices == null || correctIndex == null) {
      return Container(
        key: const ValueKey("spot_the_error"),
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.redAccent.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            if (imagePath != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(imagePath, fit: BoxFit.cover),
              ),
            const SizedBox(height: 10),
            Text("Spot the Error:", style: kActivityBodyStyle.copyWith(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(originalSentence, style: kActivityBodyStyle.copyWith(fontSize: 18, color: Colors.redAccent)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Solution"),
                    content: Text(
                      explanation,
                      style: const TextStyle(fontSize: 16),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _handleActivityCompleted();
                        },
                        child: const Text("OK"),
                      )
                    ],
                  ),
                );
              },
              child: const Text("Check Error", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      );
    }

    // If multiple-choice
    return Container(
      key: const ValueKey("spot_the_error_choice"),
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.redAccent.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imagePath != null && imagePath.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(imagePath, fit: BoxFit.cover),
            ),
          const SizedBox(height: 10),
          Text("Spot the Error:", style: kActivityBodyStyle.copyWith(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(originalSentence, style: kActivityBodyStyle.copyWith(fontSize: 18, color: Colors.redAccent)),
          const SizedBox(height: 12),
          ...choices.asMap().entries.map((entry) {
            final idx = entry.key;
            final choiceText = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: ElevatedButton(
                onPressed: () => _handleSpotErrorChoice(
                  selectedIndex: idx,
                  correctIndex: correctIndex,
                  explanation: explanation,
                  correctSound: correctSound,
                  wrongSound: wrongSound,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
                child: Text(choiceText, style: const TextStyle(fontSize: 18)),
              ),
            );
          }).toList()
        ],
      ),
    );
  }

  Future<void> _handleSpotErrorChoice({
    required int selectedIndex,
    required int correctIndex,
    required String explanation,
    String? correctSound,
    String? wrongSound,
  }) async {
    final isCorrect = (selectedIndex == correctIndex);

    // play correct/incorrect sound
    await _playActivitySound(
      isCorrect: isCorrect,
      correctSoundPath: correctSound,
      wrongSoundPath: wrongSound,
    );

    // show Lottie
    _showFeedbackAnimation(isCorrect);

    // Then show a simple dialog
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isCorrect ? "Correct!" : "Try Again!"),
        content: Text(explanation, style: const TextStyle(fontSize: 16)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (isCorrect) {
                _handleActivityCompleted();
              }
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }
}

//
// ---------------------- BELOW: SUPPORTING WIDGETS FOR DRAG & DROP ----------------------
//

class _SentenceConstructionWidget extends StatefulWidget {
  final List<String> words;
  final List<String> correctOrder;
  final String imagePath;
  final VoidCallback onActivityCompleted;
  final ValueChanged<String> onMentorExpressionChange;

  const _SentenceConstructionWidget({
    Key? key,
    required this.words,
    required this.correctOrder,
    required this.imagePath,
    required this.onActivityCompleted,
    required this.onMentorExpressionChange,
  }) : super(key: key);

  @override
  State<_SentenceConstructionWidget> createState() => _SentenceConstructionWidgetState();
}

class _SentenceConstructionWidgetState extends State<_SentenceConstructionWidget> {
  late List<String> _arrangement;
  final AudioPlayer _localAudioPlayer = AudioPlayer(); // For optional correct/wrong sounds

  @override
  void initState() {
    super.initState();
    _arrangement = List<String>.from(widget.words);
  }

  void _showFeedbackAnimation(bool isCorrect) {
    final overlay = Overlay.of(context);
    if (overlay == null) return;

    final overlayEntry = OverlayEntry(
      builder: (_) => Center(
        child: SizedBox(
          width: 180,
          height: 180,
          child: Lottie.asset(
            isCorrect
                ? 'assets/animations/activity_correct.json'
                : 'assets/animations/activity_wrong.json',
            repeat: false,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2), () => overlayEntry.remove());
  }

  Future<void> _playSound(bool isCorrect) async {
    try {
      await _localAudioPlayer.stop();
      final chosenPath = isCorrect
          ? 'sounds/correct.mp3'
          : 'sounds/incorrect.mp3';
      final finalPath = chosenPath.replaceFirst('assets/', '');
      await _localAudioPlayer.play(AssetSource(finalPath));
    } catch (e) {
      debugPrint("❌ [sentence_construction] sound error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.greenAccent.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          if (widget.imagePath.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(widget.imagePath, fit: BoxFit.cover),
            ),
          const SizedBox(height: 12),
          Text("Rearrange to form a correct sentence:", style: kActivityBodyStyle.copyWith(fontSize: 18)),
          const SizedBox(height: 10),
          Text("(Long press and drag the items)", style: kActivityBodyStyle),
          const SizedBox(height: 12),
          SizedBox(
            height: 250,
            child: ReorderableListView(
              onReorder: _onReorder,
              physics: const ClampingScrollPhysics(),
              children: <Widget>[
                for (int i = 0; i < _arrangement.length; i++)
                  ListTile(
                    key: ValueKey(_arrangement[i]),
                    title: Chip(
                      label: Text(_arrangement[i], style: const TextStyle(fontSize: 16)),
                      backgroundColor: Colors.lightBlueAccent.shade100,
                    ),
                    leading: const Icon(Icons.drag_handle),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: _checkArrangement,
            child: const Text("Check", style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final String item = _arrangement.removeAt(oldIndex);
      _arrangement.insert(newIndex, item);
    });
  }

  void _checkArrangement() async {
    final isCorrect = listEquals(_arrangement, widget.correctOrder);

    await _playSound(isCorrect);
    _showFeedbackAnimation(isCorrect);

    if (isCorrect) {
      widget.onMentorExpressionChange('mentor_celebrate_full.png');
      Future.delayed(const Duration(seconds: 1), () {
        widget.onActivityCompleted();
        widget.onMentorExpressionChange('mentor_thinking_upper.png');
      });
    } else {
      widget.onMentorExpressionChange('mentor_confused_upper.png');
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Try Again"),
          content: const Text("That sequence seems off! Long-press and reorder the items carefully."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            )
          ],
        ),
      );
    }
  }
}

// WORD BUILDER WIDGET with drag & drop
class _WordBuilderWidget extends StatefulWidget {
  final List<String> letters;
  final List<String> extraLetters;
  final String correctWord;
  final String instruction;
  final VoidCallback onActivityCompleted;
  final ValueChanged<String> onMentorExpressionChange;

  const _WordBuilderWidget({
    Key? key,
    required this.letters,
    required this.extraLetters,
    required this.correctWord,
    required this.instruction,
    required this.onActivityCompleted,
    required this.onMentorExpressionChange,
  }) : super(key: key);

  @override
  State<_WordBuilderWidget> createState() => _WordBuilderWidgetState();
}

class _WordBuilderWidgetState extends State<_WordBuilderWidget> {
  late List<String> _sourceLetters; // Draggable pool
  List<String> _targetLetters = []; // Where user arranges the letters
  final AudioPlayer _localAudioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _sourceLetters = [...widget.letters, ...widget.extraLetters]..shuffle();
  }

  void _showFeedbackAnimation(bool isCorrect) {
    final overlay = Overlay.of(context);
    if (overlay == null) return;

    final overlayEntry = OverlayEntry(
      builder: (_) => Center(
        child: SizedBox(
          width: 180,
          height: 180,
          child: Lottie.asset(
            isCorrect
                ? 'assets/animations/activity_correct.json'
                : 'assets/animations/activity_wrong.json',
            repeat: false,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2), () => overlayEntry.remove());
  }

  Future<void> _playSound(bool isCorrect) async {
    try {
      await _localAudioPlayer.stop();
      final chosenPath = isCorrect
          ? 'sounds/correct.mp3'
          : 'sounds/incorrect.mp3';
      final finalPath = chosenPath.replaceFirst('assets/', '');
      await _localAudioPlayer.play(AssetSource(finalPath));
    } catch (e) {
      debugPrint("❌ [word_builder] sound error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey("word_builder"),
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFEBEE), Color(0xFFFFCDD2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.pinkAccent.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Text("Word Builder", style: kActivityBodyStyle.copyWith(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(widget.instruction, style: kActivityBodyStyle),
          const SizedBox(height: 12),

          // Source letters
          Text("Source Letters:", style: kActivityBodyStyle.copyWith(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _sourceLetters.map((letter) {
              return Draggable<String>(
                data: letter,
                feedback: Material(
                  color: Colors.transparent,
                  child: Chip(
                    label: Text(letter, style: const TextStyle(fontSize: 18)),
                    backgroundColor: Colors.blueAccent.shade100,
                  ),
                ),
                childWhenDragging: Opacity(
                  opacity: 0.3,
                  child: Chip(
                    label: Text(letter, style: const TextStyle(fontSize: 18)),
                    backgroundColor: Colors.blueAccent.shade100,
                  ),
                ),
                child: Chip(
                  label: Text(letter, style: const TextStyle(fontSize: 18)),
                  backgroundColor: Colors.blueAccent.shade100,
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),
          Text("Arrange Here:", style: kActivityBodyStyle.copyWith(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),

          // Target area
          DragTarget<String>(
            builder: (context, candidateItems, rejectedItems) {
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueGrey.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _targetLetters.map((letter) {
                    return Draggable<String>(
                      data: letter,
                      feedback: Material(
                        color: Colors.transparent,
                        child: Chip(
                          label: Text(letter, style: const TextStyle(fontSize: 18)),
                          backgroundColor: Colors.greenAccent.shade100,
                        ),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.3,
                        child: Chip(
                          label: Text(letter, style: const TextStyle(fontSize: 18)),
                          backgroundColor: Colors.greenAccent.shade100,
                        ),
                      ),
                      child: Chip(
                        label: Text(letter, style: const TextStyle(fontSize: 18)),
                        backgroundColor: Colors.greenAccent.shade100,
                      ),
                      onDragCompleted: () {
                        // If you want to allow reordering inside the target,
                        // you'd need additional logic or multiple DragTargets.
                      },
                    );
                  }).toList(),
                ),
              );
            },
            onWillAccept: (data) => true,
            onAccept: (data) {
              setState(() {
                _sourceLetters.remove(data);
                _targetLetters.add(data);
              });
            },
          ),

          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: _checkWord,
            child: const Text("Check Word", style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }

  void _checkWord() async {
    final userWord = _targetLetters.join();
    final correct = widget.correctWord.replaceAll(' ', '');
    final isCorrect = userWord.toLowerCase() == correct.toLowerCase();

    await _playSound(isCorrect);
    _showFeedbackAnimation(isCorrect);

    if (isCorrect) {
      widget.onMentorExpressionChange('mentor_celebrate_full.png');
      Future.delayed(const Duration(seconds: 1), () {
        widget.onActivityCompleted();
        widget.onMentorExpressionChange('mentor_thinking_upper.png');
      });
    } else {
      widget.onMentorExpressionChange('mentor_confused_upper.png');
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Try Again"),
          content: Text("Hmm, that doesn’t look like '${widget.correctWord}'.\n\n"
              "Drag letters in correct order!"),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))
          ],
        ),
      );
    }
  }
}
