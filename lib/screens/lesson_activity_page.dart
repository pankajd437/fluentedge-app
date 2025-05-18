import 'package:hive/hive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:fluentedge_app/constants.dart'; // color/style constants
import 'package:fluentedge_app/widgets/animated_mentor_widget.dart';
import 'package:fluentedge_app/widgets/quiz_activity_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:fluentedge_app/data/user_state.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/foundation.dart' show listEquals;

// If using swipe_cards for FlashcardSwipeWidget
import 'package:swipe_cards/swipe_cards.dart';

//
// ------------------ Glow Shadows & Container Helpers ------------------
//

final BoxShadow kGlowBoxShadowPink = BoxShadow(
  color: Colors.pinkAccent.withOpacity(0.55),
  blurRadius: 12,
  spreadRadius: 2,
  offset: const Offset(0, 0),
);

final BoxShadow kGlowBoxShadowBlue = BoxShadow(
  color: Colors.blueAccent.withOpacity(0.45),
  blurRadius: 12,
  spreadRadius: 2,
  offset: const Offset(0, 0),
);

final BoxShadow kGlowBoxShadowGreen = BoxShadow(
  color: Colors.greenAccent.withOpacity(0.45),
  blurRadius: 12,
  spreadRadius: 2,
  offset: const Offset(0, 0),
);

/// A standard “glowing” container used by many cards
/// A standard “glowing” container used by many cards
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
      // Keep the same gradient you had (or customize as you like)
      gradient: LinearGradient(
        colors: gradientColors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      // Slightly bigger radius for a more premium feel
      borderRadius: BorderRadius.circular(24),

      // Add or override boxShadow with a darker, softer blur
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],

      // Optional: Add a subtle border
      border: Border.all(
        color: Colors.white.withOpacity(0.5),
        width: 1.5,
      ),
    ),
    child: child,
  );
}


//
// ---------- Fonts & Constants (from constants.dart) ----------
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

//
// ----------------------------------------------------------------------------
//                       LessonActivityPage
// ----------------------------------------------------------------------------
//

class LessonActivityPage extends ConsumerStatefulWidget {
  final String lessonJsonPath; // JSON location
  final String lessonTitle;

  const LessonActivityPage({
    Key? key,
    required this.lessonJsonPath,
    required this.lessonTitle,
  }) : super(key: key);

  @override
  ConsumerState<LessonActivityPage> createState() => _LessonActivityPageState();
}

class _LessonActivityPageState extends ConsumerState<LessonActivityPage> with SingleTickerProviderStateMixin {
  final List<bool> _quizResults = [];
  String _expressionName = 'mentor_thinking_upper.png';
  bool _quizFailed = false;
  bool _showNiceJobPopup = false;
  bool _showWrongAnswerPopup = false;
  bool _showXPAnimation = false;

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

  // 🛡️ New: Prevent awarding XP multiple times for same activity
  final Set<String> _xpAwardedActivityKeys = {};

  // Mentor animation
  late AnimationController _mentorAnimController;
  late Animation<double> _mentorScaleAnim;
  late Animation<double> _mentorFadeAnim;

@override
void initState() {
  super.initState();
  _loadLessonJson();

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

  // ✅ Load XP-awarded activity keys from Hive for persistence across sessions
  Hive.openBox(kHiveBoxAwardedXP).then((box) {
    final List<String> keys = box.keys.cast<String>().toList();
    _xpAwardedActivityKeys.addAll(keys);
    debugPrint("🧠 Loaded awarded XP activity keys from Hive: $_xpAwardedActivityKeys");
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

void _handleAnswerSelected(bool isCorrect) async {
  _quizResults.add(isCorrect);

  if (!isCorrect) {
    setState(() {
      _quizFailed = true;
      _expressionName = 'mentor_confused_upper.png';
      _showWrongAnswerPopup = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _showWrongAnswerPopup = false);
      }
    });
  } else {
    final String activityKey = "$_lessonId-$_currentActivityIndex";

    // 🧠 Check if XP was already awarded (even across sessions)
    final xpBox = await Hive.openBox(kHiveBoxAwardedXP);
    final alreadyAwarded = xpBox.containsKey(activityKey);

    if (!_xpAwardedActivityKeys.contains(activityKey) && !alreadyAwarded) {
      _xpAwardedActivityKeys.add(activityKey);
      await xpBox.put(activityKey, true); // ✅ Persist to Hive

      ref.read(xpProvider.notifier).incrementXP(10); // ✅ Award XP
      setState(() => _showXPAnimation = true);

      debugPrint("✅ XP awarded for $activityKey and saved to Hive.");
    } else {
      debugPrint("⚠️ Skipping XP for $activityKey — already awarded.");
    }

    setState(() {
      _expressionName = 'mentor_celebrate_full.png';
      _showNiceJobPopup = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _showNiceJobPopup = false);
      }
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

void _handleActivityCompleted() async {
  try {
    await _audioPlayer.stop();
  } catch (e) {
    debugPrint("❌ Error stopping audio in _handleActivityCompleted: $e");
  }

  if (_currentActivityIndex < _activities.length - 1) {
    setState(() {
      _currentActivityIndex++;
      _autoPlayDoneForThisActivity = false;
      _expressionName = 'mentor_thinking_upper.png';
      _quizFailed = false;
    });
  } else {
    final bool allCorrect = _quizResults.isEmpty || !_quizResults.contains(false);

    // ✅ Step 1: Sync live XP (from quizzes) to backend
    try {
      await ref.read(xpProvider.notifier).syncXPWithBackend();
    } catch (e) {
      debugPrint("❌ XP sync failed at lesson end: $e");
    }

    // ✅ Step 2: Clean and log the lessonId before passing
    final cleanLessonId = _lessonId.isNotEmpty
        ? _lessonId
        : widget.lessonTitle.replaceAll(' ', '_').toLowerCase();

    debugPrint("📦 Navigating to LessonCompletePage with lessonId: $cleanLessonId");
    debugPrint("🧠 Final quiz results: $_quizResults");
    debugPrint("✅ allCorrect evaluated to: $allCorrect");


    // ✅ Step 3: Go to completion page with proper data
    GoRouter.of(context).push('/lessonComplete', extra: {
      'lessonTitle': widget.lessonTitle,
      'lessonId': cleanLessonId,
      'isCorrect': true, // always show Congrats, no matter the quiz score
      'earnedXP': kLessonCompletionPoints, // always pass XP
      'badgeId': null,
    });
  }
}

@override
Widget build(BuildContext context) {
  final currentXP = ref.watch(xpProvider);

  return TweenAnimationBuilder<double>(
    tween: Tween(begin: 0, end: 1),
    duration: const Duration(milliseconds: 600),
    curve: Curves.easeOut,
    builder: (ctx, value, child) {
      final scale = 0.95 + (0.05 * value);
      return Transform.scale(
        scale: scale,
        child: Opacity(opacity: value, child: child),
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.lessonTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amberAccent, size: 30),
                const SizedBox(width: 4),
                Text(
                  '$currentXP XP',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF8FBFF), Color(0xFFFFFFFF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // ✅ Progress bar (wider + multicolor)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                      child: SizedBox(
                        width: 340,
                        height: 20,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: const LinearGradient(
                                  colors: [Colors.green, Colors.orange, Colors.red],
                                  stops: [0.0, 0.5, 1.0],
                                ),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: (_activities.isEmpty || _loading)
                                  ? 0
                                  : (_currentActivityIndex + 1) / _activities.length,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white.withOpacity(0.6),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 🔹 Main content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Activity ${_currentActivityIndex + 1} of ${_activities.length}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ScaleTransition(
                                scale: _mentorScaleAnim,
                                child: FadeTransition(
                                  opacity: _mentorFadeAnim,
                                  child: AnimatedMentorWidget(
                                    size: 120,
                                    expressionName: _expressionName,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              if (_showXPAnimation)
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Lottie.asset(
                                      'assets/animations/xp_appbar_sparkle.json',
                                      width: 210,
                                      repeat: false,
                                      onLoaded: (composition) {
                                        Future.delayed(composition.duration, () {
                                          if (mounted) {
                                            setState(() => _showXPAnimation = false);
                                          }
                                        });
                                      },
                                    ),
                                    const Text(
                                      "+10 XP",
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFDAA520),
                                        shadows: [
                                          Shadow(
                                            blurRadius: 4,
                                            color: Colors.black26,
                                            offset: Offset(2, 2),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            transitionBuilder: (child, animation) {
                              final slide = Tween<Offset>(
                                begin: const Offset(0.1, 0),
                                end: Offset.zero,
                              ).animate(animation);
                              return SlideTransition(
                                position: slide,
                                child: FadeTransition(opacity: animation, child: child),
                              );
                            },
                            child: buildCurrentActivity(),
                          ),

                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: (_currentActivityIndex == 0)
                                    ? null
                                    : () {
                                        setState(() {
                                          _currentActivityIndex--;
                                          _autoPlayDoneForThisActivity = false;
                                          _expressionName = 'mentor_thinking_upper.png';
                                        });
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
                ],
              ),
            ),
          ),

          // ✅ Nice Job Popup
          if (_showNiceJobPopup)
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.25,
              left: 24,
              right: 24,
              child: AnimatedOpacity(
                opacity: 1,
                duration: const Duration(milliseconds: 400),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.green.shade600.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [kGlowBoxShadowGreen],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.thumb_up, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        "Nice job!",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // ❌ Wrong Answer Popup
          if (_showWrongAnswerPopup)
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.25,
              left: 24,
              right: 24,
              child: AnimatedOpacity(
                opacity: 1,
                duration: const Duration(milliseconds: 400),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.red.shade600.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.redAccent.withOpacity(0.4),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.error_outline, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        "Oops! Try again",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}






  // --------------------------------------------------------------------
  // Inline Lottie feedback
  // --------------------------------------------------------------------
  void showFeedbackAnimation(bool isCorrect, {String? correctLottie, String? wrongLottie}) {
    final overlay = Overlay.of(context);
    if (overlay == null) return;

    final correctAnim = correctLottie ?? 'assets/animations/thumbs_up_vote.json';
    final wrongAnim = wrongLottie ?? 'assets/animations/activity_wrong.json';

    final overlayEntry = OverlayEntry(
      builder: (_) => Center(
        child: SizedBox(
          width: 180,
          height: 180,
          child: Lottie.asset(
            isCorrect ? correctAnim : wrongAnim,
            repeat: false,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2), () => overlayEntry.remove());
  }

  void playActivitySound({
    required bool isCorrect,
    String? correctSoundPath,
    String? wrongSoundPath,
  }) async {
    try {
      await _audioPlayer.stop();
      final chosenPath = isCorrect
          ? (correctSoundPath ?? 'assets/sounds/correct.mp3')
          : (wrongSoundPath ?? 'assets/sounds/incorrect.mp3');
      final finalPath = chosenPath.replaceFirst('assets/', '');
      await _audioPlayer.play(AssetSource(finalPath));
    } catch (e) {
      debugPrint("❌ Sound error: $e");
    }
  }

  // Main switcher for each activity type
  Widget buildCurrentActivity() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_loadError) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/animations/confused_thinking.json', height: 120, repeat: true),
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
        child: Text(
          "⚠️ No activities found for this lesson.",
          style: kActivityBodyStyle.copyWith(fontSize: 18),
        ),
      );
    }

    final current = _activities[_currentActivityIndex];
    final String rawType = current['type'] as String? ?? '';
    final String type = _normalizeActivityType(rawType);

    // Possibly override expression if there's a custom expression
    if (!_autoAdvanceTriggered && !_quizFailed) {
      final customExpr = current['expression'] as String?;
      _expressionName = customExpr ?? _getExpressionForActivity(type);
    }

    // -------------- Check for 'guided_self_intro' ---------------
    if (type == 'guided_self_intro') {
      return buildGuidedSelfIntro(current);
    }

    switch (type) {
      case 'mentor_intro':
        return buildMentorIntro(current);
      case 'mentor_explain':
        return buildMentorExplain(current);
      case 'quiz':
        return buildQuiz(current);
      case 'audio_clip':
        return buildAudioClip(current);
      case 'scene_image':
        return buildSceneImage(current);
      case 'text_card':
        return buildTextCard(current);
      case 'speaking_prompt':
        return buildSpeakingPrompt(current);
      case 'real_life_simulation':
        return buildRealLifeSimulation(current);
      case 'poll':
        return buildPollActivity(current);
      case 'mentor_surprise_fact':
        return buildMentorSurpriseFact(current);
      case 'badge_award':
        return buildBadgeAward(current);
      case 'recap_card':
        return buildRecapCard(current);
      case 'next_lesson_preview':
        return buildNextLessonPreview(current);
      case 'dialogue_reconstruction':
        return buildDialogueReconstructionSingleCard(current);
      case 'fill_in_the_blanks':
        return buildFillInTheBlanks(current);
      case 'sentence_construction':
        return buildSentenceConstruction(current);
      case 'today_vocabulary':
        return buildTodayVocabulary(current);
      case 'word_builder':
        return buildWordBuilder(current);
      case 'short_stories':
        return buildShortStories(current);
      case 'spot_the_error':
        return buildSpotTheError(current);
      case 'flashcards':
        return buildFlashcardActivity(current);
      default:
        return Text(
          "Activity type not recognized: $type",
          style: kActivityBodyStyle.copyWith(fontWeight: FontWeight.w600, fontSize: 18),
        );
    }
  }

  /// Normalizing older type names
  String _normalizeActivityType(String rawType) {
  switch (rawType) {
    case 'auto_audio':
      return 'mentor_intro';
    case 'message':
      return 'mentor_explain';
    case 'explanation': // ✅ Add this line
      return 'mentor_explain';
    case 'audio':
      return 'audio_clip';
    case 'image':
      return 'scene_image';
    case 'text':
    case 'text_display':
      return 'text_card';
    case 'roleplay':
      return 'real_life_simulation';
    case 'badge':
      return 'badge_award';
    case 'tip':
      return 'mentor_surprise_fact';
    case 'poll':
      return 'poll';
    case 'mini_stories':
      return 'short_stories';
    default:
      return rawType;
  }
}

  String _getExpressionForActivity(String type) {
    switch (type) {
      case 'mentor_intro':
        return 'mentor_analytical_upper.png';
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
        return 'mentor_pointing_upper.png';
      case 'poll':
      case 'mentor_surprise_fact':
        return 'mentor_surprised_upper.png';
      case 'badge_award':
        return 'mentor_proud_full.png';
      case 'recap_card':
        return 'mentor_tip_upper.png';
      case 'next_lesson_preview':
        return 'mentor_thumbs_up_full.png';
      case 'dialogue_reconstruction':
        return 'mentor_pointing_upper.png';
      case 'fill_in_the_blanks':
        return 'mentor_thinking_upper.png';
      case 'sentence_construction':
      case 'word_builder':
        return 'mentor_pointing_upper.png';
      case 'today_vocabulary':
        return 'mentor_encouraging_upper.png';
      case 'short_stories':
        return 'mentor_silly_upper.png';
      case 'spot_the_error':
        return 'mentor_confused_upper.png';
      case 'flashcards':
        return 'mentor_reassure_upper.png';
      default:
        return 'mentor_thinking_upper.png';
    }
  }

  // -------------- NEW: BUILD GUIDED SELF INTRO ACTIVITY --------------
  Widget buildGuidedSelfIntro(Map<String, dynamic> current) {
    final cardTitle = current['title']?.toString() ?? 'Self-Intro Builder';
    final instructions = current['instructions']?.toString() ?? 'Answer each step briefly.';
    final steps = (current['steps'] as List?) ?? [];
    final combineFormat = current['combineFormat']?.toString() ?? 'Hello! {nameLine} ...';

return Container(
  margin: const EdgeInsets.symmetric(vertical: 10),
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    gradient: LinearGradient(
  colors: [Color(0xFF8E24AA), Color(0xFFBA68C8)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
),
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.2),
        blurRadius: 6,
        spreadRadius: 2,
      ),
    ],
  ),
  child: GuidedSelfIntroWidget(
        cardTitle: cardTitle,
        instructions: instructions,
        steps: List<Map<String, dynamic>>.from(steps),
        combineFormat: combineFormat,
        onDone: _handleActivityCompleted,
      ),
    );
  }

  // -------------- All the "buildXYZ" methods --------------
  // They now show "title" in the UI instead of "type" to keep it friendlier.

Widget buildMentorIntro(Map<String, dynamic> current) {
  final imagePath = current['imagePath']?.toString() ?? '';
  final text = current['text']?.toString() ?? '';
  final title = current['title']?.toString() ?? 'Lesson Intro';
  final audioPath = current['audioPath']?.toString();

  // Play mentor intro audio automatically once
  if (!_autoPlayDoneForThisActivity && audioPath != null && audioPath.isNotEmpty) {
    Future.delayed(const Duration(milliseconds: 400), () async {
      try {
        await _audioPlayer.stop();
        final finalPath = audioPath.replaceFirst('assets/', '');
        await _audioPlayer.play(AssetSource(finalPath));
        setState(() {
          _autoPlayDoneForThisActivity = true;
        });
      } catch (e) {
        debugPrint("❌ MentorIntro audio error: $e");
      }
    });
  }

  return buildGlowingContainer(
    gradientColors: [Colors.deepPurple, Colors.deepPurpleAccent],
    shadows: [kGlowBoxShadowPink],
    child: Column(
      children: [
        if (imagePath.isNotEmpty)
          Image.asset(
            imagePath,
            errorBuilder: (_, __, ___) => const Text(
              "Could not load intro image",
              style: TextStyle(color: Colors.white),
            ),
          ),
        const SizedBox(height: 10),
        Text(title, style: kVibrantTitleStyle.copyWith(fontSize: kBaseFontSize + 2)),
        const SizedBox(height: 8),
        Text(text, style: kVibrantMessageStyle.copyWith(fontSize: kBaseFontSize)),
        if (audioPath != null && audioPath.isNotEmpty) ...[
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              try {
                await _audioPlayer.stop();
                final finalPath = audioPath.replaceFirst('assets/', '');
                await _audioPlayer.play(AssetSource(finalPath));
              } catch (e) {
                debugPrint("❌ Replay intro audio error: $e");
              }
            },
            icon: const Icon(Icons.volume_up, color: Colors.white),
            label: const Text("Replay Audio", style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white30),
          ),
        ],
      ],
    ),
  );
}



Widget buildMentorExplain(Map<String, dynamic> current) {
  final text = current['text']?.toString() ?? '';
  final title = current['title']?.toString() ?? 'Mentor:';
  final imagePath = current['imagePath']?.toString() ?? '';
  final audioPath = current['audioPath']?.toString();

  // Auto-play mentor audio once
  if (!_autoPlayDoneForThisActivity && audioPath != null && audioPath.isNotEmpty) {
    Future.delayed(const Duration(milliseconds: 400), () async {
      try {
        await _audioPlayer.stop();
        final finalPath = audioPath.replaceFirst('assets/', '');
        await _audioPlayer.play(AssetSource(finalPath));
        setState(() {
          _autoPlayDoneForThisActivity = true;
        });
      } catch (e) {
        debugPrint("❌ MentorExplain audio error: $e");
      }
    });
  }

  // ✅ Ensure audio stops if user moves to next activity
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final currentIndex = _activities.indexOf(current);
    if (_currentActivityIndex != currentIndex && _autoPlayDoneForThisActivity) {
      _audioPlayer.stop(); // 🔇 Stop mentor audio when moving away
    }
  });

  return buildGlowingContainer(
    gradientColors: [Colors.pink, Colors.orange],
    shadows: [kGlowBoxShadowPink],
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: kVibrantTitleStyle),
        const SizedBox(height: 8),
        if (imagePath.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Text("⚠️ Image not found", style: TextStyle(color: Colors.white)),
            ),
          ),
        if (imagePath.isNotEmpty) const SizedBox(height: 12),
        AnimatedTextKit(
          isRepeatingAnimation: false,
          animatedTexts: [
            TypewriterAnimatedText(
              text,
              textStyle: kVibrantMessageStyle.copyWith(fontSize: kBaseFontSize + 2),
              speed: const Duration(milliseconds: 40),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (audioPath != null && audioPath.isNotEmpty)
          ElevatedButton.icon(
            onPressed: () async {
              try {
                await _audioPlayer.stop();
                final finalPath = audioPath.replaceFirst('assets/', '');
                await _audioPlayer.play(AssetSource(finalPath));
              } catch (e) {
                debugPrint("❌ Replay audio error: $e");
              }
            },
            icon: const Icon(Icons.volume_up, color: Colors.white),
            label: const Text("Replay Mentor Audio", style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white54),
          ),
      ],
    ),
  );
}




Widget buildQuiz(Map<String, dynamic> current) {
  final title = current['title']?.toString() ?? 'Quiz Time';

  return buildGlowingContainer(
    gradientColors: [Colors.white, Colors.white],
    shadows: [
      BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 6, spreadRadius: 2),
    ],
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: kVibrantTitleStyle.copyWith(color: Colors.black87)),
        const SizedBox(height: 8),
        QuizActivityWidget(
          question: current['question'] ?? 'No question',
          options: List<String>.from(current['options'] ?? []),
          correctIndex: current['answerIndex'] ?? 0,
          hints: List<String>.from(current['hints'] ?? []),
          allowRetry: current['allowRetry'] ?? false,
          encouragementOnFail: current['encouragementOnFail'] ?? '',
          correctSound: current['correctSound'] as String?,
          wrongSound: current['wrongSound'] as String?,
          onCompleted: _handleActivityCompleted,
          onAnswerSelected: _handleAnswerSelected, // ✅ important for popup
        ),
      ],
    ),
  );
}


  Widget buildAudioClip(Map<String, dynamic> current) {
    final caption = current['title']?.toString() ?? current['caption']?.toString() ?? 'Audio Clip';
    final audioPath = current['audioPath']?.toString() ?? '';

    return buildGlowingContainer(
      gradientColors: [Colors.cyan, Colors.teal],
      shadows: [kGlowBoxShadowBlue],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(caption, style: kVibrantTitleStyle),
          const SizedBox(height: 8),
          Text("Audio: $audioPath", style: kVibrantBodyStyle),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              try {
                await _audioPlayer.stop();
                final finalPath = audioPath.replaceFirst('assets/', '');
                await _audioPlayer.play(AssetSource(finalPath));
              } catch (e) {
                debugPrint("Audio error: $e");
              }
            },
            child: const Text("Play Audio"),
          ),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: _handleActivityCompleted, child: const Text("Next")),
        ],
      ),
    );
  }

Widget buildSceneImage(Map<String, dynamic> current) {
  final caption = current['title']?.toString() ?? current['caption']?.toString() ?? 'Scene Image';
  final imagePath = current['imagePath']?.toString() ?? '';
  final audioPath = current['audioPath']?.toString();

  // Auto-play audio once per activity
  if (!_autoPlayDoneForThisActivity && audioPath != null && audioPath.isNotEmpty) {
    Future.delayed(const Duration(milliseconds: 400), () async {
      try {
        await _audioPlayer.stop();
        final finalPath = audioPath.replaceFirst('assets/', '');
        await _audioPlayer.play(AssetSource(finalPath));
        setState(() {
          _autoPlayDoneForThisActivity = true;
        });
      } catch (e) {
        debugPrint("🎧 Scene image audio error: $e");
      }
    });
  }

  // Ensure audio is stopped before moving to next activity
  Future.delayed(const Duration(milliseconds: 200)).then((_) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_currentActivityIndex == _activities.indexOf(current)) {
        _audioPlayer.onPlayerComplete.listen((event) {
          _audioPlayer.stop(); // Safety net in case audio runs long
        });
      }
    });
  });

  return buildGlowingContainer(
    gradientColors: [Colors.blueGrey, Colors.grey],
    shadows: [kGlowBoxShadowBlue],
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(caption, style: kVibrantTitleStyle.copyWith(fontSize: 20, fontWeight: FontWeight.normal)),
        const SizedBox(height: 10),
        Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Text("Image not found"),
        ),
      ],
    ),
  );
}

Widget buildTextCard(Map<String, dynamic> current) {
  final title = current['title']?.toString() ?? 'Note';
  final body = current['body']?.toString() ?? '...';
  final audioPath = current['audioPath']?.toString();

  // Auto-play audio once
  if (!_autoPlayDoneForThisActivity && audioPath != null && audioPath.isNotEmpty) {
    Future.delayed(const Duration(milliseconds: 400), () async {
      try {
        await _audioPlayer.stop();
        final finalPath = audioPath.replaceFirst('assets/', '');
        await _audioPlayer.play(AssetSource(finalPath));
        setState(() {
          _autoPlayDoneForThisActivity = true;
        });
      } catch (e) {
        debugPrint("❌ TextCard audio error: $e");
      }
    });
  }

  final tableRegex = RegExp(r'((\|.*\n)+)');
  final tableMatch = tableRegex.firstMatch(body);
  final tableContent = tableMatch?.group(0) ?? '';
  final bodyBeforeTable = body.substring(0, tableMatch?.start ?? body.length).trim();
  final bodyAfterTable = body.substring((tableMatch?.end ?? body.length)).trim();
  final bool hasTable = tableContent.isNotEmpty;

  final gradientColors = hasTable
      ? [const Color(0xFF3F51B5), const Color(0xFF5C6BC0)]
      : [const Color(0xFF0D47A1), const Color(0xFF42A5F5)];

  return buildGlowingContainer(
    gradientColors: gradientColors,
    shadows: [kGlowBoxShadowBlue],
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: kVibrantTitleStyle),
        const SizedBox(height: 8),

        if (audioPath != null && audioPath.isNotEmpty)
          ElevatedButton.icon(
            onPressed: () async {
              try {
                await _audioPlayer.stop();
                final finalPath = audioPath.replaceFirst('assets/', '');
                await _audioPlayer.play(AssetSource(finalPath));
              } catch (e) {
                debugPrint("❌ TextCard replay audio error: $e");
              }
            },
            icon: const Icon(Icons.volume_up, color: Colors.white),
            label: const Text("Replay Audio", style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white30),
          ),

        if (bodyBeforeTable.isNotEmpty)
          MarkdownBody(
            data: bodyBeforeTable,
            styleSheet: MarkdownStyleSheet(
              p: kVibrantBodyStyle.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
              listBullet: kVibrantBodyStyle.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
              h1: kVibrantBodyStyle.copyWith(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              h2: kVibrantBodyStyle.copyWith(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              h3: kVibrantBodyStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              listIndent: 24,
              blockSpacing: 10,
            ),
          ),

        if (tableContent.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1976D2), Color(0xFF4DD0E1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [kGlowBoxShadowBlue],
            ),
            child: MarkdownBody(
              data: tableContent,
              styleSheet: MarkdownStyleSheet(
                tableHead: kVibrantBodyStyle.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                tableBody: kVibrantBodyStyle.copyWith(color: Colors.white),
                tableBorder: TableBorder.all(color: Colors.white, width: 1.5),
              ),
            ),
          ),
        ],

        if (bodyAfterTable.isNotEmpty) ...[
          const SizedBox(height: 12),
          MarkdownBody(
            data: bodyAfterTable,
            styleSheet: MarkdownStyleSheet(
              p: kVibrantBodyStyle.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
              listBullet: kVibrantBodyStyle.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
              h1: kVibrantBodyStyle.copyWith(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              h2: kVibrantBodyStyle.copyWith(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              h3: kVibrantBodyStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              listIndent: 24,
              blockSpacing: 10,
            ),
          ),
        ],
      ],
    ),
  );
}

Widget buildSpeakingPrompt(Map<String, dynamic> current) {
  final title = current['title']?.toString() ?? 'Speaking Prompt';
  final prompt = current['prompt']?.toString() ?? '';
  final audioSupport = current['audioSupport'] as bool? ?? false;
  final audioPath = current['audioPath']?.toString();

  // Auto-play audio once
  if (!_autoPlayDoneForThisActivity && audioPath != null && audioPath.isNotEmpty) {
    Future.delayed(const Duration(milliseconds: 400), () async {
      try {
        await _audioPlayer.stop();
        final finalPath = audioPath.replaceFirst('assets/', '');
        await _audioPlayer.play(AssetSource(finalPath));
        setState(() {
          _autoPlayDoneForThisActivity = true;
        });
      } catch (e) {
        debugPrint("❌ Speaking Prompt audio error: $e");
      }
    });
  }

  return buildGlowingContainer(
    gradientColors: [Colors.deepPurple, Colors.purpleAccent],
    shadows: [kGlowBoxShadowPink],
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: kVibrantTitleStyle),
        const SizedBox(height: 8),
        Text(prompt, style: kVibrantBodyStyle),
        if (audioSupport && audioPath != null && audioPath.isNotEmpty) ...[
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () async {
              try {
                await _audioPlayer.stop();
                final finalPath = audioPath.replaceFirst('assets/', '');
                await _audioPlayer.play(AssetSource(finalPath));
              } catch (e) {
                debugPrint("❌ Replay error: $e");
              }
            },
            icon: const Icon(Icons.volume_up, color: Colors.white),
            label: const Text("Replay Audio", style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white54),
          ),
        ],
        const SizedBox(height: 16),
        ElevatedButton(onPressed: _handleActivityCompleted, child: const Text("Done")),
      ],
    ),
  );
}


  Widget buildRealLifeSimulation(Map<String, dynamic> current) {
    final title = current['title']?.toString() ?? 'Real-Life Simulation';
    final text = current['text']?.toString() ?? '';

    return buildGlowingContainer(
      gradientColors: [Colors.pink.shade200, Colors.blue.shade200],
      shadows: [kGlowBoxShadowPink],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: kVibrantTitleStyle),
          const SizedBox(height: 8),
          Text(text, style: kVibrantBodyStyle),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: _handleActivityCompleted, child: const Text("Next")),
        ],
      ),
    );
  }

Widget buildPollActivity(Map<String, dynamic> current) {
  final headingText = current['title']?.toString() ?? 'Community Poll';
  final question = current['question']?.toString() ?? 'No question';
  final rawOptions = current['options'] as List? ?? [];
  final options = List<String>.from(rawOptions);
  final rawFeedback = current['dynamicFeedback'] as Map? ?? {};
  final dynamicFeedback = rawFeedback.map((k, v) => MapEntry(k.toString(), v.toString()));

  // 🎵 Background music
  final AudioPlayer backgroundPlayer = AudioPlayer();
  backgroundPlayer.setReleaseMode(ReleaseMode.loop);
  backgroundPlayer.play(AssetSource('audio/background_loop_gamified.mp3'), volume: 0.2);

  void stopBackgroundMusic() async {
    await backgroundPlayer.stop();
  }

  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: Colors.white.withOpacity(0.07),
          blurRadius: 4,
          offset: const Offset(0, -2),
        ),
      ],
      border: Border.all(
        color: Colors.grey.withOpacity(0.2),
        width: 1.5,
      ),
    ),
    child: PollActivityWidget(
      headingText: headingText,
      question: question,
      options: options,
      dynamicFeedback: dynamicFeedback,
      onSubmit: () {
        stopBackgroundMusic(); // 🛑 Stop on submit
      },
      onDone: () {
        stopBackgroundMusic(); // 🛑 Stop on done
        _handleActivityCompleted();
      },
    ),
  );
}

  Widget buildMentorSurpriseFact(Map<String, dynamic> current) {
  final title = current['title']?.toString() ?? 'Surprise Fact';
  final body = current['body']?.toString() ?? '...';
  final imagePath = current['imagePath']?.toString() ?? '';
  final audioPath = current['audioPath']?.toString();

  // ✅ Auto play audio if available and not already played
  if (!_autoPlayDoneForThisActivity && audioPath != null && audioPath.isNotEmpty) {
    Future.delayed(const Duration(milliseconds: 400), () async {
      try {
        await _audioPlayer.stop();
        final finalPath = audioPath.replaceFirst('assets/', '');
        await _audioPlayer.play(AssetSource(finalPath));
        setState(() {
          _autoPlayDoneForThisActivity = true;
        });
      } catch (e) {
        debugPrint("❌ SurpriseFact audio error: $e");
      }
    });
  }

  return buildGlowingContainer(
    gradientColors: [Colors.indigo.shade800, Colors.indigo.shade600],
    shadows: [kGlowBoxShadowPink],
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.isNotEmpty ? title : 'Surprise Fact',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 8),
        if (imagePath.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imagePath,
              errorBuilder: (_, __, ___) => const SizedBox(
                height: 100,
                child: Center(child: Text("Image not found", style: TextStyle(color: Colors.white))),
              ),
            ),
          ),
        if (imagePath.isNotEmpty) const SizedBox(height: 8),
        Text(body, style: const TextStyle(color: Colors.white, fontSize: 20)),
        const SizedBox(height: 16),
        if (audioPath != null && audioPath.isNotEmpty)
          ElevatedButton.icon(
            onPressed: () async {
              try {
                await _audioPlayer.stop();
                final finalPath = audioPath.replaceFirst('assets/', '');
                await _audioPlayer.play(AssetSource(finalPath));
              } catch (e) {
                debugPrint("❌ Replay SurpriseFact audio error: $e");
              }
            },
            icon: const Icon(Icons.volume_up, color: Colors.white),
            label: const Text("Replay Audio", style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white24),
          ),
        ElevatedButton(
          onPressed: _handleActivityCompleted,
          child: const Text("Got it"),
        ),
      ],
    ),
  );
}


Widget buildBadgeAward(Map<String, dynamic> current) {
  final title = current['title']?.toString() ?? 'Badge Award';
  final description = current['description']?.toString() ?? 'No description';
  final animationPath = current['animation']?.toString() ?? '';
  final audioPath = current['audioPath']?.toString();

  if (!_autoPlayDoneForThisActivity && audioPath != null && audioPath.isNotEmpty) {
    Future.delayed(const Duration(milliseconds: 400), () async {
      try {
        await _audioPlayer.stop();
        final finalPath = audioPath.replaceFirst('assets/', '');
        await _audioPlayer.play(AssetSource(finalPath));
        setState(() {
          _autoPlayDoneForThisActivity = true;
        });
      } catch (e) {
        debugPrint("❌ BadgeAward audio error: $e");
      }
    });
  }

  return buildGlowingContainer(
    gradientColors: [Colors.green.shade600, Colors.green.shade300],
    shadows: [kGlowBoxShadowGreen],
    child: Column(
      children: [
        Text(title, style: kVibrantTitleStyle),
        const SizedBox(height: 8),
        if (animationPath.isNotEmpty)
          SizedBox(
            height: 120,
            child: Lottie.asset(animationPath, fit: BoxFit.contain, repeat: false),
          ),
        const SizedBox(height: 8),
        Text(description, style: kVibrantBodyStyle),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _handleActivityCompleted,
          child: const Text("Continue"),
        ),
      ],
    ),
  );
}


  Widget buildRecapCard(Map<String, dynamic> current) {
    final title = current['title']?.toString() ?? 'Recap Card';
    final summary = current['summary']?.toString() ?? 'No recap';

    return buildGlowingContainer(
      gradientColors: [Colors.brown.shade700, Colors.brown.shade400],
      shadows: [
        BoxShadow(color: Colors.brown.withOpacity(0.5), blurRadius: 10, spreadRadius: 2),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: kVibrantTitleStyle),
          const SizedBox(height: 8),
          Text(summary, style: kVibrantBodyStyle),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: _handleActivityCompleted, child: const Text("Next")),
        ],
      ),
    );
  }

  Widget buildNextLessonPreview(Map<String, dynamic> current) {
    final nextTitle = current['title']?.toString() ?? 'Next Lesson';
    final description = current['description']?.toString() ?? '...';

    return buildGlowingContainer(
      gradientColors: [Colors.blueGrey, Colors.grey],
      shadows: [kGlowBoxShadowBlue],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(nextTitle, style: kVibrantTitleStyle),
          const SizedBox(height: 8),
          Text(description, style: kVibrantBodyStyle),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: _handleActivityCompleted, child: const Text("Finish")),
        ],
      ),
    );
  }

Widget buildDialogueReconstructionSingleCard(Map<String, dynamic> current) {
  final scenarioTitle = current['contextTitle']?.toString() ?? '';
  final messages = List<Map<String, dynamic>>.from(current['messages'] ?? []);
  final learningTakeaway = current['learningTakeaway']?.toString() ?? '';
  final title = current['title']?.toString() ?? 'Dialogue:';

  // 🎵 Start background loop
  final AudioPlayer backgroundPlayer = AudioPlayer();
  backgroundPlayer.setReleaseMode(ReleaseMode.loop);
  backgroundPlayer.play(AssetSource('audio/background_loop_gamified.mp3'), volume: 0.2);

  void stopBackgroundMusic() async {
    await backgroundPlayer.stop();
  }

  return buildGlowingContainer(
    gradientColors: [Color(0xFF4A148C), Color(0xFF7E57C2)],
    shadows: [kGlowBoxShadowBlue],
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: kVibrantTitleStyle),
        const SizedBox(height: 8),
        DialogueReconstructionWidgetSingle(
          scenarioTitle: scenarioTitle,
          messages: messages,
          learningTakeaway: learningTakeaway,
          onDone: () {
            stopBackgroundMusic(); // ✅ stop loop before navigating
            _handleActivityCompleted();
          },
        ),
      ],
    ),
  );
}


Widget buildFillInTheBlanks(Map<String, dynamic> current) {
  final title = current['title']?.toString() ?? 'Fill in the Blanks';
  final sentence = current['sentence']?.toString() ?? '';
  final correctWord = current['correctWord']?.toString() ?? '';
  final hints = List<String>.from(current['hints'] ?? []);
  final imagePath = current['imagePath']?.toString();
  final correctSound = current['correctSound'] as String?;
  final wrongSound = current['wrongSound'] as String?;
  final correctLottie = 'assets/animations/thumbs_up_vote.json';
  final wrongLottie = 'assets/animations/confused_thinking.json';
  final submitLabel = current['submitLabel']?.toString() ?? 'Check';
  final feedbackCorrect = current['feedback']?['correctText']?.toString() ?? '';
  final feedbackWrong = current['feedback']?['wrongText']?.toString() ?? '';

  return buildGlowingContainer(
    gradientColors: [Colors.redAccent, Colors.pinkAccent],
    shadows: [kGlowBoxShadowPink],
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: kVibrantTitleStyle),
        const SizedBox(height: 8),
        FillInTheBlanksWidget(
          sentence: sentence,
          correctWord: correctWord,
          hints: hints,
          imagePath: imagePath,
          correctSoundPath: correctSound,
          wrongSoundPath: wrongSound,
          correctLottie: correctLottie,
          wrongLottie: wrongLottie,
          submitLabel: submitLabel,
          feedbackCorrect: feedbackCorrect,
          feedbackWrong: feedbackWrong,

          // ✅ Call _handleAnswerSelected to trigger feedback UI
          onCompleted: (isCorrect) {
            _handleAnswerSelected(isCorrect);
          },

          playFeedbackAnimation: (isCorrect) {
            showFeedbackAnimation(
              isCorrect,
              correctLottie: correctLottie,
              wrongLottie: wrongLottie,
            );
          },
          playSound: (isCorrect) {
            playActivitySound(
              isCorrect: isCorrect,
              correctSoundPath: correctSound,
              wrongSoundPath: wrongSound,
            );
          },
        ),
      ],
    ),
  );
}

  Widget buildSentenceConstruction(Map<String, dynamic> current) {
    final title = current['title']?.toString() ?? 'Sentence Construction';
    final words = List<String>.from(current['words'] ?? []);
    final correctOrder = List<String>.from(current['correctOrder'] ?? []);
    final imagePath = current['imagePath']?.toString();

    return buildGlowingContainer(
      gradientColors: [Colors.lightBlue, Colors.lightBlueAccent],
      shadows: [kGlowBoxShadowBlue],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: kVibrantTitleStyle),
          const SizedBox(height: 8),
          SentenceConstructionWidget(
            words: words,
            correctOrder: correctOrder,
            imagePath: imagePath,
            onCompleted: (isCorrect) {
              showFeedbackAnimation(
                isCorrect,
                correctLottie: 'assets/animations/star_pop.json',
                wrongLottie: 'assets/animations/alert_attention.json',
              );
              playActivitySound(isCorrect: isCorrect);
              _handleAnswerSelected(isCorrect);
            },
          ),
        ],
      ),
    );
  }

Widget buildTodayVocabulary(Map<String, dynamic> current) {
  final title = current['title']?.toString() ?? "Today's Vocabulary";
  final vocabItems = List<Map<String, dynamic>>.from(current['vocabItems'] ?? []);

  // ✅ Background music setup
  final AudioPlayer backgroundPlayer = AudioPlayer();
  backgroundPlayer.setReleaseMode(ReleaseMode.loop);
  backgroundPlayer.play(
    AssetSource('audio/background_loop_gamified.mp3'),
    volume: 0.2,
  );

  // ✅ Stop music when activity completes (either via "Done" or global "Next")
  void stopBackgroundMusic() async {
    await backgroundPlayer.stop();
  }

  // Inject stop logic into the global callback
  final VoidCallback originalHandleCompleted = _handleActivityCompleted;
  void wrappedHandleCompleted() {
    stopBackgroundMusic();
    originalHandleCompleted();
  }

  return buildGlowingContainer(
    gradientColors: [Colors.purple, Colors.deepPurpleAccent],
    shadows: [kGlowBoxShadowPink],
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: kVibrantTitleStyle),
        const SizedBox(height: 8),
        TodayVocabularyWidget(
          vocabItems: vocabItems,
          onDone: wrappedHandleCompleted, // ✅ Injected stop logic here
        ),
      ],
    ),
  );
}

Widget buildWordBuilder(Map<String, dynamic> current) {
  final title = current['title']?.toString() ?? 'Word Builder';
  final instruction = current['instruction']?.toString() ??
      "Drag tiles (letters or words) into the box to build the correct sentence or word.";

  final correctSound = current['correctSound'] as String? ?? 'assets/sounds/correct.mp3';
  final wrongSound = current['wrongSound'] as String? ?? 'assets/sounds/incorrect.mp3';

  final correctLottie = 'assets/animations/mic_success.json';
  final wrongLottie = 'assets/animations/confused_thinking.json';

  final multiSets = current['multiWordSets'] as List<dynamic>?;

  if (multiSets != null && multiSets.isNotEmpty) {
    return buildGlowingContainer(
      gradientColors: [Colors.orange.shade700, Colors.orangeAccent],
      shadows: [kGlowBoxShadowPink],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: kVibrantTitleStyle),
          const SizedBox(height: 8),
          MultiSetWordBuilderWidget(
            instruction: instruction,
            sets: multiSets.map((e) => Map<String, dynamic>.from(e)).toList(),
            onAllDone: () async {
              // ✅ Trigger feedback before advancing
              showFeedbackAnimation(true, correctLottie: correctLottie);
              playActivitySound(isCorrect: true, correctSoundPath: correctSound);

              // Delay to let feedback show fully
              await Future.delayed(const Duration(seconds: 2));

              // ✅ Then trigger completion and feedback popup
              _handleAnswerSelected(true);
            },
          ),
        ],
      ),
    );
  }

  final List<String> letters = List<String>.from(
    current['words'] ?? current['letters'] ?? [],
  );

  final correctWord = current['correctWord']?.toString() ?? '';
  final extraLetters = List<String>.from(current['extraLetters'] ?? []);

  return buildGlowingContainer(
    gradientColors: [Colors.purple.shade500, Colors.deepPurple.shade200],
    shadows: [kGlowBoxShadowPink],
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: kVibrantTitleStyle),
        const SizedBox(height: 8),
        WordBuilderWidget(
          letters: letters,
          correctWord: correctWord,
          extraLetters: extraLetters,
          instruction: instruction,
          onCompleted: (isCorrect) {
            showFeedbackAnimation(
              isCorrect,
              correctLottie: correctLottie,
              wrongLottie: wrongLottie,
            );
            playActivitySound(
              isCorrect: isCorrect,
              correctSoundPath: correctSound,
              wrongSoundPath: wrongSound,
            );
            _handleAnswerSelected(isCorrect);
          },
        ),
      ],
    ),
  );
}



Widget buildShortStories(Map<String, dynamic> current) {
  final title = current['title']?.toString() ?? 'Short Stories';
  final scenes = List<Map<String, dynamic>>.from(current['scenes'] ?? []);
  final audioPath = current['audioPath']?.toString();

  if (!_autoPlayDoneForThisActivity && audioPath != null && audioPath.isNotEmpty) {
    Future.delayed(const Duration(milliseconds: 400), () async {
      try {
        await _audioPlayer.stop();
        final finalPath = audioPath.replaceFirst('assets/', '');
        await _audioPlayer.play(AssetSource(finalPath));
        setState(() {
          _autoPlayDoneForThisActivity = true;
        });
      } catch (e) {
        debugPrint("❌ ShortStories audio error: $e");
      }
    });
  }

  return buildGlowingContainer(
    gradientColors: [Colors.teal.shade800, Colors.teal.shade400],
    shadows: [kGlowBoxShadowGreen],
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: kVibrantTitleStyle),
        const SizedBox(height: 8),
        ShortStoriesWidget(
          scenes: scenes,
          onDone: _handleActivityCompleted,
        ),
      ],
    ),
  );
}


  Widget buildSpotTheError(Map<String, dynamic> current) {
    final title = current['title']?.toString() ?? 'Spot the Error';
    final instruction = current['instruction']?.toString() ??
        "Spot the incorrect element in the sentence below. Click on the wrong word.";
    final originalSentence = current['originalSentence']?.toString() ?? '';
    final choices = List<String>.from(current['choices'] ?? []);
    final correctChoiceIndex = current['correctChoiceIndex'] ?? 0;
    final explanation = current['explanation']?.toString() ?? '';
    final imagePath = current['imagePath']?.toString();

    return buildGlowingContainer(
      gradientColors: [Colors.teal.shade600, Colors.teal.shade200],
      shadows: [kGlowBoxShadowPink],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: kVibrantTitleStyle),
          const SizedBox(height: 8),
          SpotTheErrorWidget(
            instruction: instruction,
            originalSentence: originalSentence,
            choices: choices,
            correctChoiceIndex: correctChoiceIndex,
            explanation: explanation,
            imagePath: imagePath,
            onCompleted: (isCorrect) {
              showFeedbackAnimation(
                isCorrect,
                correctLottie: 'assets/animations/star_pop.json',
                wrongLottie: 'assets/animations/alert_attention.json',
              );
              playActivitySound(isCorrect: isCorrect);
              _handleAnswerSelected(isCorrect);
            },
          ),
          const SizedBox(height: 8),
          Text(
            "Tip: Carefully check each option to see which version fixes the error.",
            style: kVibrantBodyStyle,
          ),
        ],
      ),
    );
  }

  Widget buildFlashcardActivity(Map<String, dynamic> current) {
    final title = current['title']?.toString() ?? "Flashcards";
    final rawCards = current['cards'] as List? ?? [];
    final List<Map<String, String>> flashcards = rawCards.map<Map<String, String>>((e) {
      final term = e['term']?.toString() ?? '...';
      final definition = e['definition']?.toString() ?? 'No definition';
      return {"term": term, "definition": definition};
    }).toList();

    final instruction = current['instruction']?.toString() ??
        "Swipe left/right to navigate through flashcards. Tap the card to reveal more info.";

    return FlashcardSwipeWidget(
      title: title,
      flashcards: flashcards,
      onComplete: _handleActivityCompleted,
      instruction: instruction,
    );
  }
}

// ----------------------------------------------------------------------------
// NEW WIDGET: GuidedSelfIntroWidget
// ----------------------------------------------------------------------------

class GuidedSelfIntroWidget extends StatefulWidget {
  final String cardTitle;       // e.g. "Self-Intro Builder"
  final String instructions;    // e.g. "Answer each step briefly..."
  final List<Map<String, dynamic>> steps;
  final String combineFormat;   // e.g. "Hello! {nameLine} ... {hobbyLine}"
  final VoidCallback onDone;

  const GuidedSelfIntroWidget({
    Key? key,
    required this.cardTitle,
    required this.instructions,
    required this.steps,
    required this.combineFormat,
    required this.onDone,
  }) : super(key: key);

  @override
  State<GuidedSelfIntroWidget> createState() => _GuidedSelfIntroWidgetState();
}

class _GuidedSelfIntroWidgetState extends State<GuidedSelfIntroWidget> {
  // We store user inputs in a map: {keyName -> userText}
  final Map<String, String> _answers = {};
  // To show final combined text
  String? _combinedIntro;
  bool _finalized = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.cardTitle, style: kVibrantTitleStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(
          widget.instructions,
          style: kVibrantBodyStyle.copyWith(fontStyle: FontStyle.italic),
        ),
        const SizedBox(height: 12),

        if (!_finalized) ..._buildStepsFields(),

        if (_finalized && _combinedIntro != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white54,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _combinedIntro!,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (!_finalized)
              ElevatedButton(
                onPressed: _finalizeIntro,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryBlue,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Show My Intro"),
              )
            else ...[
              ElevatedButton(
                onPressed: widget.onDone,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryBlue,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Done"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _finalized = false;
                    _combinedIntro = null;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Edit Again"),
              ),
            ],
          ],
        ),
      ],
    );
  }

  List<Widget> _buildStepsFields() {
    final fields = <Widget>[];
    for (final step in widget.steps) {
      final prompt = step['prompt']?.toString() ?? '...';
      final placeholder = step['placeholder']?.toString() ?? '';
      final keyName = step['keyName']?.toString() ?? '';

fields.add(
  Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          prompt,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: placeholder,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
          ),
          onChanged: (val) {
            _answers[keyName] = val;
          },
        ),
      ],
    ),
  ),
);
    }
    return fields;
  }

  void _finalizeIntro() {
    // Build the final intro string from combineFormat
    String output = widget.combineFormat;
    for (final step in widget.steps) {
      final keyName = step['keyName']?.toString() ?? '';
      final userValue = _answers[keyName]?.trim() ?? '';
      // Replace {keyName} with userValue
      output = output.replaceAll('{$keyName}', userValue);
    }

    setState(() {
      _combinedIntro = output;
      _finalized = true;
    });
  }
}

// ----------------------------------------------------------------------------
// FLASHCARDS, POLL, FILLINTHEBLANKS, etc. WIDGETS
// ----------------------------------------------------------------------------

class FlashcardSwipeWidget extends StatefulWidget {
  final String title;
  final List<Map<String, String>> flashcards;
  final VoidCallback onComplete;
  final String instruction;

  const FlashcardSwipeWidget({
    Key? key,
    required this.title,
    required this.flashcards,
    required this.onComplete,
    required this.instruction,
  }) : super(key: key);

  @override
  State<FlashcardSwipeWidget> createState() => _FlashcardSwipeWidgetState();
}

class _FlashcardSwipeWidgetState extends State<FlashcardSwipeWidget> {
  late List<SwipeItem> _swipeItems;
  late MatchEngine _matchEngine;

  final List<List<Color>> _flashcardColorSets = const [
    [Color(0xFF4A148C), Color(0xFFD500F9)],
    [Color(0xFF0D47A1), Color(0xFF42A5F5)],
    [Color(0xFF1B5E20), Color(0xFF66BB6A)],
    [Color(0xFFBF360C), Color(0xFFFF7043)],
    [Color(0xFF311B92), Color(0xFF7E57C2)],
    [Color(0xFF424242), Color(0xFF757575)],
    [Color(0xFF880E4F), Color(0xFFFF4081)],
    [Color(0xFF006064), Color(0xFF26C6DA)],
    [Color(0xFFB71C1C), Color(0xFFEF5350)],
    [Color(0xFF1A237E), Color(0xFF5C6BC0)],
    [Color(0xFF004D40), Color(0xFF26A69A)],
    [Color(0xFF3E2723), Color(0xFF8D6E63)],
  ];

  @override
  void initState() {
    super.initState();
    _swipeItems = widget.flashcards.map((cardMap) {
      return SwipeItem(
        content: cardMap,
        likeAction: () {},
        nopeAction: () {},
        superlikeAction: () {},
        onSlideUpdate: (_) async {},
      );
    }).toList();

    _matchEngine = MatchEngine(swipeItems: _swipeItems);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(widget.title, style: kVibrantTitleStyle.copyWith(fontSize: kBaseFontSize + 4)),
        const SizedBox(height: 8),
        Text(
          widget.instruction,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, color: Colors.black87, fontStyle: FontStyle.italic),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 400,
          child: SwipeCards(
            matchEngine: _matchEngine,
            itemBuilder: (ctx, index) {
              final cardData = _swipeItems[index].content as Map<String, String>;
              final term = cardData["term"] ?? "...";
              final definition = cardData["definition"] ?? "...";

              final colorSet = _flashcardColorSets[index % _flashcardColorSets.length];

              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: colorSet,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [kGlowBoxShadowPink],
                ),
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(term,
                            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                            textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        Text(definition,
                            style: const TextStyle(fontSize: 18, color: Colors.white), textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ),
              );
            },
            onStackFinished: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("All flashcards done!")),
              );
              widget.onComplete();
            },
            itemChanged: (SwipeItem item, int index) {},
            upSwipeAllowed: false,
            fillSpace: true,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            Icon(Icons.arrow_left, size: 30, color: Colors.grey),
            Text("Swipe left / right to browse", style: TextStyle(fontSize: 16)),
            Icon(Icons.arrow_right, size: 30, color: Colors.grey),
          ],
        ),
      ],
    );
  }
}

class PollActivityWidget extends StatefulWidget {
  final String headingText;
  final String question;
  final List<String> options;
  final Map<String, String> dynamicFeedback;
  final VoidCallback onSubmit;
  final VoidCallback onDone;

  const PollActivityWidget({
    Key? key,
    required this.headingText,
    required this.question,
    required this.options,
    required this.dynamicFeedback,
    required this.onSubmit,
    required this.onDone,
  }) : super(key: key);

  @override
  State<PollActivityWidget> createState() => _PollActivityWidgetState();
}

class _PollActivityWidgetState extends State<PollActivityWidget> {
  int? _selectedIndex;
  bool _submitted = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.headingText, style: kVibrantTitleStyle.copyWith(color: Colors.black87)),
        const SizedBox(height: 8),
        Text(widget.question, style: const TextStyle(fontSize: 16, color: Colors.black87)),
        const SizedBox(height: 10),
        ...List.generate(widget.options.length, (index) {
          final optionText = widget.options[index];
          final isSelected = (_selectedIndex == index);

          return InkWell(
            onTap: _submitted
                ? null
                : () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [Colors.pinkAccent, Colors.orangeAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : const LinearGradient(
                        colors: [Colors.lightBlueAccent, Colors.lightGreenAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [kGlowBoxShadowBlue],
              ),
              child: Text(
                optionText,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
          );
        }),
        const SizedBox(height: 12),
        if (!_submitted)
          ElevatedButton(
            onPressed: _selectedIndex == null
                ? null
                : () {
                    setState(() {
                      _submitted = true;
                    });
                    widget.onSubmit();

                    final idx = _selectedIndex?.toString() ?? '';
                    final feedback = widget.dynamicFeedback[idx] ?? "No feedback available.";

                    showDialog(
                      context: context,
                      builder: (ctx) {
                        return AlertDialog(
                          title: const Text("Your Selection Feedback"),
                          content: Text(feedback),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: const Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Submit"),
          )
        else ...[
          ElevatedButton(
            onPressed: widget.onDone,
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Done"),
          ),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------
//  FillInTheBlanksWidget
// ---------------------------------------------------------------------
class FillInTheBlanksWidget extends StatefulWidget {
  final String sentence;
  final String correctWord;
  final List<String> hints;
  final String? imagePath;
  final String? correctSoundPath;
  final String? wrongSoundPath;
  final String? correctLottie;
  final String? wrongLottie;
  final String submitLabel;
  final String feedbackCorrect;
  final String feedbackWrong;
  final ValueChanged<bool> onCompleted;
  final void Function(bool) playSound;
  final void Function(bool) playFeedbackAnimation;

  const FillInTheBlanksWidget({
    Key? key,
    required this.sentence,
    required this.correctWord,
    required this.hints,
    this.imagePath,
    this.correctSoundPath,
    this.wrongSoundPath,
    this.correctLottie,
    this.wrongLottie,
    required this.submitLabel,
    required this.feedbackCorrect,
    required this.feedbackWrong,
    required this.onCompleted,
    required this.playFeedbackAnimation,
    required this.playSound,
  }) : super(key: key);

  @override
  State<FillInTheBlanksWidget> createState() => _FillInTheBlanksWidgetState();
}

class _FillInTheBlanksWidgetState extends State<FillInTheBlanksWidget> {
  final TextEditingController _controller = TextEditingController();
  String? _feedback;
  bool _answered = false;

  @override
  Widget build(BuildContext context) {
    final parts = widget.sentence.split('______');
    final hasBlank = parts.length > 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.imagePath != null && widget.imagePath!.isNotEmpty) ...[
          Image.asset(
            widget.imagePath!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const SizedBox(height: 80, child: Center(child: Text("Image error"))),
          ),
          const SizedBox(height: 10),
        ],
        if (hasBlank)
          RichText(
            text: TextSpan(
              style: kVibrantBodyStyle,
              children: [
                TextSpan(text: parts[0]),
                const TextSpan(text: ' ______ '),
                if (parts.length > 1) TextSpan(text: parts[1]),
              ],
            ),
          )
        else
          Text(widget.sentence, style: kVibrantBodyStyle),
        const SizedBox(height: 12),
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: "Type your word here...",
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        if (!_answered) ...[
          Row(
            children: [
              if (widget.hints.isNotEmpty)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.lightbulb),
                  onSelected: (_) {},
                  itemBuilder: (BuildContext context) {
                    return widget.hints.map((hint) {
                      return PopupMenuItem<String>(value: hint, child: Text(hint));
                    }).toList();
                  },
                  tooltip: "Hints",
                ),
              const Spacer(),
              ElevatedButton(
                onPressed: _checkAnswer,
                child: Text(widget.submitLabel),
              ),
            ],
          ),
        ] else ...[
          Text(_feedback ?? '', style: kVibrantBodyStyle.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () =>
                widget.onCompleted(_controller.text.trim().toLowerCase() == widget.correctWord.toLowerCase()),
            child: const Text("Continue"),
          ),
        ],
      ],
    );
  }

  void _checkAnswer() {
    final userAnswer = _controller.text.trim().toLowerCase();
    final isCorrect = userAnswer == widget.correctWord.toLowerCase();

    widget.playFeedbackAnimation(isCorrect);
    widget.playSound(isCorrect);
    widget.onCompleted(isCorrect);           // ✅ trigger popup immediately

    setState(() {
      _answered = true;
      _feedback = isCorrect ? widget.feedbackCorrect : widget.feedbackWrong;
    });
  }
}

// ---------------------------------------------------------------------
//  DialogueReconstructionWidgetSingle
// ---------------------------------------------------------------------
class DialogueReconstructionWidgetSingle extends StatelessWidget {
  final String scenarioTitle;
  final List<Map<String, dynamic>> messages;
  final String learningTakeaway;
  final VoidCallback onDone;

  const DialogueReconstructionWidgetSingle({
    Key? key,
    required this.scenarioTitle,
    required this.messages,
    required this.learningTakeaway,
    required this.onDone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (scenarioTitle.isNotEmpty)
          Text(
            "Scenario: $scenarioTitle",
            style: kActivityBodyStyle.copyWith(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        const SizedBox(height: 8),
        ...messages.map((msg) {
          final isSender = msg['isSender'] as bool? ?? false;
          final text = msg['text']?.toString() ?? '';
          final avatarPath = msg['avatar']?.toString() ?? '';

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isSender) ...[
                  CircleAvatar(
                    backgroundImage: avatarPath.isNotEmpty
                        ? AssetImage(avatarPath)
                        : const AssetImage('assets/images/chat_friend_blue.png'),
                    radius: 30,
                  ),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSender ? const Color(0xFFDCF8C6) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(text, style: const TextStyle(fontSize: 16, color: Colors.black)),
                  ),
                ),
                if (isSender) ...[
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundImage: avatarPath.isNotEmpty
                        ? AssetImage(avatarPath)
                        : const AssetImage('assets/images/chat_user_pink.png'),
                    radius: 30,
                  ),
                ],
              ],
            ),
          );
        }).toList(),
        if (learningTakeaway.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text("Takeaway:", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
          const SizedBox(height: 4),
          Text(learningTakeaway, style: const TextStyle(fontSize: 14, color: Colors.white)),
        ],
        const SizedBox(height: 16),
        ElevatedButton(onPressed: onDone, child: const Text("Next")),
      ],
    );
  }
}

// ---------------------------------------------------------------------
//  SentenceConstructionWidget
// ---------------------------------------------------------------------
class SentenceConstructionWidget extends StatefulWidget {
  final List<String> words;
  final List<String> correctOrder;
  final String? imagePath;
  final ValueChanged<bool> onCompleted;

  const SentenceConstructionWidget({
    Key? key,
    required this.words,
    required this.correctOrder,
    this.imagePath,
    required this.onCompleted,
  }) : super(key: key);

  @override
  State<SentenceConstructionWidget> createState() => _SentenceConstructionWidgetState();
}

class _SentenceConstructionWidgetState extends State<SentenceConstructionWidget> {
  List<String> _userOrder = [];

  @override
  void initState() {
    super.initState();
    _userOrder = [...widget.words];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.imagePath != null && widget.imagePath!.isNotEmpty) ...[
          Image.asset(
            widget.imagePath!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const SizedBox(height: 80, child: Center(child: Text("Image error"))),
          ),
          const SizedBox(height: 10),
        ],
        Text("Drag and rearrange the words to form the correct sentence:", style: kVibrantBodyStyle),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          children: _userOrder.map((word) {
            return Draggable<String>(
              data: word,
              feedback: Material(
                color: Colors.transparent,
                child: _buildWordChip(word, isDragging: true),
              ),
              childWhenDragging: _buildWordChip(word, isPlaceholder: true),
              child: DragTarget<String>(
                builder: (ctx, candidateData, rejectedData) {
                  return _buildWordChip(word);
                },
                onWillAccept: (incomingWord) => incomingWord != null,
                onAccept: (incomingWord) {
                  setState(() {
                    final oldIndex = _userOrder.indexOf(incomingWord);
                    final newIndex = _userOrder.indexOf(word);
                    _userOrder.removeAt(oldIndex);
                    _userOrder.insert(newIndex, incomingWord);
                  });
                },
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            final isCorrect = listEquals(_userOrder, widget.correctOrder);
            widget.onCompleted(isCorrect);
          },
          child: const Text("Check Order"),
        ),
      ],
    );
  }

  Widget _buildWordChip(String word, {bool isDragging = false, bool isPlaceholder = false}) {
    Color bgColor;
    if (isPlaceholder) {
      bgColor = Colors.grey.shade300;
    } else if (isDragging) {
      bgColor = Colors.orangeAccent;
    } else {
      bgColor = Colors.brown; // distinct color for normal state
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
      child: Text(word, style: const TextStyle(color: Colors.white, fontSize: 18)),
    );
  }
}

// ---------------------------------------------------------------------
//  TodayVocabularyWidget
// ---------------------------------------------------------------------
class TodayVocabularyWidget extends StatelessWidget {
  final List<Map<String, dynamic>> vocabItems;
  final VoidCallback onDone;

  const TodayVocabularyWidget({
    Key? key,
    required this.vocabItems,
    required this.onDone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (vocabItems.isEmpty) {
      return const Text("No vocabulary items found.");
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // NOTE: We assume the "title" was shown by the parent caller,
        // so we just list the items here.
        const SizedBox(height: 4),
        ...vocabItems.map((vocab) {
          final word = vocab['word']?.toString() ?? '...';
          final meaning = vocab['meaning']?.toString() ?? '...';
          final image = vocab['image']?.toString() ?? '';

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.white, Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 8,
                  spreadRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                if (image.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      image,
                      fit: BoxFit.cover,
                      width: 60,
                      height: 60,
                      errorBuilder: (_, __, ___) => const Icon(Icons.error),
                    ),
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(word,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
                      const SizedBox(height: 4),
                      Text(meaning, style: const TextStyle(fontSize: 14, color: Colors.black87)),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        const SizedBox(height: 8),
        ElevatedButton(onPressed: onDone, child: const Text("Done"))
      ],
    );
  }
}

// ---------------------------------------------------------------------
//  WordBuilderWidget
// ---------------------------------------------------------------------
class WordBuilderWidget extends StatefulWidget {
  final List<String> letters;
  final String correctWord;
  final List<String> extraLetters;
  final String instruction;
  final ValueChanged<bool> onCompleted;

  const WordBuilderWidget({
    Key? key,
    required this.letters,
    required this.correctWord,
    required this.extraLetters,
    required this.instruction,
    required this.onCompleted,
  }) : super(key: key);

  @override
  State<WordBuilderWidget> createState() => _WordBuilderWidgetState();
}

class _WordBuilderWidgetState extends State<WordBuilderWidget> {
  List<String> _lettersPool = [];
  List<String> _chosenLetters = [];

  @override
  void initState() {
    super.initState();
    _lettersPool = [...widget.letters, ...widget.extraLetters]..shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.instruction, style: kVibrantBodyStyle),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _lettersPool.map((letter) {
            return Draggable<String>(
              data: letter,
              feedback: _buildLetterBubble(letter, isDragging: true),
              childWhenDragging: _buildLetterBubble(letter, isPlaceholder: true),
              child: _buildLetterBubble(letter),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        Container(
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DragTarget<String>(
            onWillAccept: (letter) => true,
            onAccept: (letter) {
              setState(() {
                _chosenLetters.add(letter);
                _lettersPool.remove(letter);
              });
            },
            builder: (ctx, candidateData, rejectedData) {
              return Center(
                child: _chosenLetters.isEmpty
                    ? const Text("Drop letters here", style: TextStyle(fontSize: 16, color: Colors.black54))
                    : Wrap(
                        spacing: 8,
                        children: _chosenLetters.map((letter) {
                          return _buildLetterBubble(letter, isInDropZone: true);
                        }).toList(),
                      ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Text(
          widget.correctWord.contains(' ')
              ? "Formed Sentence: ${_chosenLetters.join(' ')}"
              : "Formed Word: ${_chosenLetters.join('')}",
          style: kVibrantBodyStyle.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _checkWord,
          child: const Text("Check"),
        ),
      ],
    );
  }

  Widget _buildLetterBubble(String letter,
      {bool isDragging = false, bool isPlaceholder = false, bool isInDropZone = false}) {
    Color bgColor;
    if (isPlaceholder) {
      bgColor = Colors.transparent;
    } else if (isDragging) {
      bgColor = Colors.orangeAccent;
    } else if (isInDropZone) {
      bgColor = Colors.teal;
    } else {
      bgColor = Colors.deepPurpleAccent;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
      child: Text(letter, style: const TextStyle(fontSize: 18, color: Colors.white)),
    );
  }

  void _checkWord() {
    final bool isSentence = widget.correctWord.contains(' ');
    final formed = isSentence
        ? _chosenLetters.join(' ').trim()
        : _chosenLetters.join().trim();

    final correct = widget.correctWord.trim().toUpperCase();
    final isCorrect = formed.toUpperCase() == correct;

    widget.onCompleted(isCorrect);
  }
}

// ---------------------------------------------------------------------
//  ShortStoriesWidget
// ---------------------------------------------------------------------
class ShortStoriesWidget extends StatelessWidget {
  final List<Map<String, dynamic>> scenes;
  final VoidCallback onDone;

  const ShortStoriesWidget({
    Key? key,
    required this.scenes,
    required this.onDone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (scenes.isEmpty) {
      return const Text("No story scenes found.");
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...scenes.map((scene) {
          final imagePath = scene['imagePath']?.toString() ?? '';
          final text = scene['text']?.toString() ?? '';
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: Column(
              children: [
                if (imagePath.isNotEmpty)
                  Image.asset(imagePath, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Text("Image not found")),
                const SizedBox(height: 8),
                Text(text, style: kVibrantBodyStyle),
              ],
            ),
          );
        }).toList(),
        ElevatedButton(onPressed: onDone, child: const Text("Done"))
      ],
    );
  }
}

// ---------------------------------------------------------------------
//  SpotTheErrorWidget
// ---------------------------------------------------------------------
class SpotTheErrorWidget extends StatefulWidget {
  final String instruction;
  final String originalSentence;
  final List<String> choices;
  final int correctChoiceIndex;
  final String explanation;
  final String? imagePath;
  final ValueChanged<bool> onCompleted;

  const SpotTheErrorWidget({
    Key? key,
    required this.instruction,
    required this.originalSentence,
    required this.choices,
    required this.correctChoiceIndex,
    required this.explanation,
    this.imagePath,
    required this.onCompleted,
  }) : super(key: key);

  @override
  State<SpotTheErrorWidget> createState() => _SpotTheErrorWidgetState();
}

class _SpotTheErrorWidgetState extends State<SpotTheErrorWidget> {
  int? _selectedIndex;
  bool _answered = false;
  bool _isCorrect = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.imagePath != null && widget.imagePath!.isNotEmpty) ...[
          Image.asset(
            widget.imagePath!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Text("Image not found"),
          ),
          const SizedBox(height: 8),
        ],
        Text(widget.instruction, style: kVibrantBodyStyle),
        const SizedBox(height: 8),
        Text("Original Sentence: ${widget.originalSentence}", style: kVibrantBodyStyle),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: List.generate(widget.choices.length, (index) {
            final choice = widget.choices[index];
            return ChoiceChip(
              label: Text(choice),
              backgroundColor: Colors.yellowAccent,
              selectedColor: Colors.blueAccent,
              selected: _selectedIndex == index,
              onSelected: _answered
                  ? null
                  : (selected) {
                      setState(() {
                        _selectedIndex = selected ? index : null;
                      });
                    },
            );
          }),
        ),
        const SizedBox(height: 12),
        if (!_answered)
          ElevatedButton(
            onPressed: _checkAnswer,
            child: const Text("Check"),
          )
        else ...[
          const SizedBox(height: 8),
          Text(widget.explanation, style: kVibrantBodyStyle),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              widget.onCompleted(_isCorrect); // fallback
            },
            child: const Text("Continue"),
          ),
        ]
      ],
    );
  }

  void _checkAnswer() {
    final isCorrect = _selectedIndex == widget.correctChoiceIndex;

    widget.onCompleted(isCorrect); // ✅ Trigger Nice/Oops feedback immediately
    setState(() {
      _answered = true;
      _isCorrect = isCorrect;
    });
  }
}
 
class MultiSetWordBuilderWidget extends StatefulWidget {
  final String instruction;
  final List<Map<String, dynamic>> sets;
  final VoidCallback onAllDone;

  const MultiSetWordBuilderWidget({
    Key? key,
    required this.instruction,
    required this.sets,
    required this.onAllDone,
  }) : super(key: key);

  @override
  State<MultiSetWordBuilderWidget> createState() => _MultiSetWordBuilderWidgetState();
}

class _MultiSetWordBuilderWidgetState extends State<MultiSetWordBuilderWidget> {
  int _currentSetIndex = 0;
  bool _completedCurrentSet = false;
  int _resetKey = 0;

  @override
  Widget build(BuildContext context) {
    if (_currentSetIndex >= widget.sets.length) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6A1B9A), Color(0xFF8E24AA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("✅ All sets completed! 🎉", style: TextStyle(fontSize: 16, color: Colors.white)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: widget.onAllDone,
              child: const Text("Done"),
            ),
          ],
        ),
      );
    }

    final setData = widget.sets[_currentSetIndex];
    final correctWord = setData['correctWord']?.toString() ?? '';
    final List<String> words = List<String>.from(setData['words'] ?? setData['letters'] ?? []);
    final List<String> extraLetters = List<String>.from(setData['extraLetters'] ?? []);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6A1B9A), Color(0xFF8E24AA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Set ${_currentSetIndex + 1} of ${widget.sets.length}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Text(
            widget.instruction,
            style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          WordBuilderWidget(
            key: ValueKey("set_${_currentSetIndex}_reset_$_resetKey"),
            letters: words,
            correctWord: correctWord,
            extraLetters: extraLetters,
            instruction: "",
            onCompleted: (isCorrect) async {
              if (isCorrect) {
                await showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("✅ Correct!"),
                    content: Text("You've formed: $correctWord"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text("OK"),
                      ),
                    ],
                  ),
                );
                setState(() {
                  _completedCurrentSet = true;
                });
              } else {
                await showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("❌ Try Again"),
                    content: const Text("That's not the correct answer."),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          setState(() {
                            _resetKey++; // 🔁 Force rebuild
                          });
                        },
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 12),
          if (_completedCurrentSet)
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _currentSetIndex++;
                  _completedCurrentSet = false;
                  _resetKey = 0;
                });
              },
              child: _currentSetIndex < widget.sets.length - 1
                  ? const Text("Next Set")
                  : const Text("Finish"),
            ),
        ],
      ),
    );
  }
}
