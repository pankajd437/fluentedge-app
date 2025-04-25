import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:fluentedge_app/constants.dart';
import 'package:fluentedge_app/widgets/animated_mentor_widget.dart';
import 'package:fluentedge_app/widgets/quiz_activity_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:fluentedge_app/data/user_state.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

//
// ---------- REPLACED OLD LIST WITH NEW APPROVED MENTOR EXPRESSIONS ----------
//
// # ✅ NEW Approved Mentor Expressions
//   - assets/images/mentor_expressions/
//   - assets/images/mentor_expressions/mentor_analytical_upper.png
//   - assets/images/mentor_expressions/mentor_audio_ready_upper.png
//   - assets/images/mentor_expressions/mentor_celebrate_full.png
//   - assets/images/mentor_expressions/mentor_confused_upper.png
//   - assets/images/mentor_expressions/mentor_curious_upper.png
//   - assets/images/mentor_expressions/mentor_encouraging_upper.png
//   - assets/images/mentor_expressions/mentor_excited_full.png
//   - assets/images/mentor_expressions/mentor_pointing_full.png
//   - assets/images/mentor_expressions/mentor_proud_full.png
//   - assets/images/mentor_expressions/mentor_reassure_upper.png
//   - assets/images/mentor_expressions/mentor_sad_upper.png
//   - assets/images/mentor_expressions/mentor_silly_upper.png
//   - assets/images/mentor_expressions/mentor_sleepy_upper.png
//   - assets/images/mentor_expressions/mentor_surprised_upper.png
//   - assets/images/mentor_expressions/mentor_thinking_upper.png
//   - assets/images/mentor_expressions/mentor_thumbs_up_full.png
//   - assets/images/mentor_expressions/mentor_tip_upper.png
//   - assets/images/mentor_expressions/mentor_wave_smile_full.png
//
// ---------------------------------------------------------------------------

//
// ---------- VIBRANT COLORS ----------
const Color vibrantBlue = Color(0xFF007BFF);
const Color vibrantPink = Color(0xFFE83E8C);

const Color refinedGreenStart = Color(0xFF388E3C);
const Color refinedGreenEnd = Color(0xFF66BB6A);

const Color pastelOrange = Color(0xFFFFE5B4);
const Color pastelYellow = Color(0xFFFFFFB5);

//
// ---------- FONT & STYLE CONSTANTS ----------
const double kBaseFontSize = 20.0;

const TextStyle kActivityTitleStyle = TextStyle(
  fontSize: kBaseFontSize + 4,
  fontWeight: FontWeight.bold,
  color: Colors.black87,
);

const TextStyle kActivityBodyStyle = TextStyle(
  fontSize: kBaseFontSize,
  color: Colors.black87,
  height: 1.5,
  fontWeight: FontWeight.w400,
);

const TextStyle kMessageStyle = TextStyle(
  fontSize: kBaseFontSize,
  color: Colors.black87,
  height: 1.5,
  fontWeight: FontWeight.w400,
);

final TextStyle kVibrantCaptionStyle = TextStyle(
  fontSize: kBaseFontSize - 2,
  color: Colors.white,
  fontStyle: FontStyle.italic,
);

const TextStyle kVibrantTitleStyle = TextStyle(
  fontSize: kBaseFontSize + 4,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

const TextStyle kVibrantBodyStyle = TextStyle(
  fontSize: kBaseFontSize,
  color: Colors.white,
  height: 1.5,
  fontWeight: FontWeight.w400,
);

const TextStyle kVibrantMessageStyle = TextStyle(
  fontSize: kBaseFontSize,
  color: Colors.white,
  height: 1.5,
  fontWeight: FontWeight.w400,
);

const TextStyle kAudioInstructionStyle = TextStyle(
  fontSize: kBaseFontSize + 2,
  fontWeight: FontWeight.w600,
  color: Color(0xFF004D40),
);

const TextStyle kSpeakingPromptTitleStyleNew = TextStyle(
  fontSize: kBaseFontSize + 2,
  fontWeight: FontWeight.bold,
  color: Colors.white,
  shadows: [
    Shadow(
      offset: Offset(1, 1),
      blurRadius: 2,
      color: Colors.black26,
    )
  ],
);

Widget buildActivityContainer({
  Key? key,
  required Widget child,
  required List<Color> gradientColors,
  required Color shadowColor,
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
      boxShadow: [
        BoxShadow(
          color: shadowColor.withOpacity(0.3),
          blurRadius: 10,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: child,
  );
}

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

class _LessonActivityPageState extends State<LessonActivityPage> {
  final List<bool> _quizResults = [];

  // Default expression => 'mentor_thinking_upper.png'
  String _expressionName = 'mentor_thinking_upper.png';

  bool _quizFailed = false;
  List<dynamic> _activities = [];
  int _currentActivityIndex = 0;
  bool _loading = true;
  bool _loadError = false;

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _autoPlayDoneForThisActivity = false;
  bool _autoAdvanceTriggered = false;

  @override
  void initState() {
    super.initState();
    _loadLessonJson();
  }

  Future<void> _loadLessonJson() async {
    try {
      final String content = await rootBundle.loadString(widget.lessonJsonPath);
      final data = jsonDecode(content);
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
      setState(() => _quizFailed = true);
    }
    // Switch expression based on correctness
    setState(() {
      // If correct => 'mentor_celebrate_full.png', else => 'mentor_encouraging_upper.png'
      _expressionName = isCorrect
          ? 'mentor_celebrate_full.png'
          : 'mentor_encouraging_upper.png';
    });

    if (isCorrect && !_autoAdvanceTriggered) {
      _autoAdvanceTriggered = true;
      Future.delayed(const Duration(seconds: 1), () {
        _handleActivityCompleted();
        setState(() {
          // Reset to 'mentor_thinking_upper.png' after moving to next activity
          _expressionName = 'mentor_thinking_upper.png';
          _autoAdvanceTriggered = false;
        });
      });
    }
  }

  void _retryQuiz() {
    setState(() => _quizFailed = false);
  }

  void _handleActivityCompleted() {
    if (_currentActivityIndex < _activities.length - 1) {
      setState(() {
        _currentActivityIndex++;
        _autoPlayDoneForThisActivity = false;
        // Reset expression to 'mentor_thinking_upper.png'
        _expressionName = 'mentor_thinking_upper.png';
        _quizFailed = false;
      });
    } else {
      final bool allCorrect = _quizResults.isNotEmpty && !_quizResults.contains(false);
      GoRouter.of(context).push('/lessonComplete', extra: {
        'lessonTitle': widget.lessonTitle,
        'lessonId': widget.lessonTitle.replaceAll(' ', '_').toLowerCase(),
        'isCorrect': allCorrect,
        'earnedXP': allCorrect ? kLessonCompletionPoints : 0,
        'badgeId': null,
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("🧾 LessonActivityPage: no menu, smaller appbar font, refined card design.");

    // Wrap the entire Scaffold in fade+zoom
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
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
          elevation: 0,
          backgroundColor: kPrimaryBlue,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => context.pop(),
          ),
          title: Text(
            widget.lessonTitle,
            style: const TextStyle(
              fontSize: 17, // smaller to avoid overflow
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        // Custom smaller bottom bar with centered Home icon
        bottomNavigationBar: BottomAppBar(
          color: kPrimaryBlue,
          child: SizedBox(
            height: 50, // smaller height for bottom bar
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 36, // bigger home icon
                  icon: const Icon(Icons.home),
                  color: Colors.white,
                  onPressed: () {
                    GoRouter.of(context).go('/coursesDashboard');
                  },
                ),
              ],
            ),
          ),
        ),
        body: Container(
          // Light gray to white background
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF5F5F5), Color(0xFFFFFFFF)],
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
                  // Activity indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Activity ${_currentActivityIndex + 1} of ${_activities.length}",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Mentor
                  Align(
                    alignment: Alignment.centerLeft,
                    child: AnimatedMentorWidget(
                      size: 110,
                      expressionName: _expressionName, // e.g. 'mentor_thinking_upper.png'
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Activity content via AnimatedSwitcher
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) {
                      final slideAnimation = Tween<Offset>(
                        begin: const Offset(0.1, 0),
                        end: Offset.zero,
                      ).animate(animation);

                      return SlideTransition(
                        position: slideAnimation,
                        child: FadeTransition(opacity: animation, child: child),
                      );
                    },
                    child: _buildCurrentActivity(),
                  ),
                  const SizedBox(height: 30),

                  // Previous/Next Buttons
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
                                    // revert to 'mentor_thinking_upper.png'
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
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
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
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
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
            style: kActivityBodyStyle.copyWith(color: Colors.redAccent),
          ),
        ],
      );
    }
    if (_activities.isEmpty) {
      return Center(
        key: const ValueKey("empty"),
        child: Text("⚠️ No activities found for this lesson.", style: kActivityBodyStyle),
      );
    }

    final current = _activities[_currentActivityIndex];
    final type = current['type'] as String? ?? '';

    switch (type) {
      case 'auto_audio':
        return _buildAutoAudio(current);
      case 'quiz':
        return _buildQuiz(current);
      case 'audio':
        return _buildAudio(current);
      case 'image':
        return _buildImage(current);
      case 'text':
      case 'text_display':
        return _buildTextDisplay(current);
      case 'poll':
        return _buildPoll(current);
      case 'tip':
        return _buildTip(current);
      case 'message':
        return _buildMessage(current);
      case 'speaking_prompt':
        return _buildSpeakingPrompt(current);
      case 'badge':
        return _buildBadge(current);
      case 'roleplay':
        return _buildRoleplay(current);
      default:
        return Text(
          "🚧 Unsupported activity type: $type",
          style: kActivityBodyStyle.copyWith(fontWeight: FontWeight.w600),
          key: const ValueKey("unsupported"),
        );
    }
  }

  Widget _buildAutoAudio(Map<String, dynamic> activity) {
    final audioPath = activity['audioPath']?.toString() ?? '';
    final text = activity['text']?.toString() ?? '';
    final allowPause = activity['allowPause'] == true;

    if (!_autoPlayDoneForThisActivity && audioPath.isNotEmpty) {
      _autoPlayDoneForThisActivity = true;
      Future.microtask(() async {
        try {
          await _audioPlayer.stop();
          final relative = audioPath.startsWith('assets/')
              ? audioPath.replaceFirst('assets/', '')
              : audioPath;
          debugPrint("🔊 Auto-playing audio: $relative");
          await _audioPlayer.play(AssetSource(relative));
        } catch (e) {
          debugPrint("❌ Auto-audio failed: $e");
        }
      });
    }

    return buildActivityContainer(
      key: const ValueKey("auto_audio"),
      gradientColors: [vibrantBlue.withOpacity(0.95), vibrantBlue],
      shadowColor: Colors.deepOrangeAccent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (text.trim().isNotEmpty)
            Text(text, style: kVibrantMessageStyle),
          const SizedBox(height: 12),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  await _audioPlayer.stop();
                  if (audioPath.isNotEmpty) {
                    final relative = audioPath.startsWith('assets/')
                        ? audioPath.replaceFirst('assets/', '')
                        : audioPath;
                    debugPrint("🔊 Re-playing audio: $relative");
                    await _audioPlayer.play(AssetSource(relative));
                  }
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text("Replay"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(width: 10),
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
        ],
      ),
    );
  }

  Widget _buildQuiz(Map<String, dynamic> current) {
    final rawHints = current['hints'];
    List<String>? hints;
    if (rawHints is List) {
      final stringHints = rawHints.whereType<String>().toList();
      if (stringHints.isNotEmpty) hints = stringHints;
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
            boxShadow: [
              BoxShadow(
                color: refinedGreenStart.withOpacity(0.8),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
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
            label: const Text("Try Again", style: TextStyle(fontSize: 16)),
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

  Widget _buildAudio(Map<String, dynamic> current) {
    final audioPath = current['audioPath']?.toString() ?? '';
    final caption = current['caption']?.toString() ?? '';

    final List<Color> audioGradient = [
      const Color(0xFF4DB6AC),
      const Color(0xFF80CBC4),
    ];

    return buildActivityContainer(
      key: const ValueKey("audio"),
      gradientColors: audioGradient,
      shadowColor: Colors.tealAccent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (caption.isNotEmpty)
            Text(
              caption,
              style: kAudioInstructionStyle,
            ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () async {
              await _audioPlayer.stop();
              if (audioPath.trim().isNotEmpty) {
                final relative = audioPath.startsWith('assets/')
                    ? audioPath.replaceFirst('assets/', '')
                    : audioPath;
                debugPrint("🔊 Attempting audio: $relative");
                await _audioPlayer.play(AssetSource(relative));
              } else {
                debugPrint("❌ No valid audioPath found for 'audio' activity.");
              }
            },
            icon: const Icon(Icons.volume_up, size: 24),
            label: const Text("Play Audio", style: TextStyle(fontSize: 16)),
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

  Widget _buildImage(Map<String, dynamic> current) {
    final caption = current['caption']?.toString() ?? '';
    final path = current['imagePath']?.toString() ?? '';

    return buildActivityContainer(
      key: const ValueKey("image"),
      gradientColors: [vibrantPink.withOpacity(0.95), vibrantPink],
      shadowColor: Colors.deepPurpleAccent,
      child: Column(
        children: [
          if (caption.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                caption,
                style: kVibrantCaptionStyle,
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

  Widget _buildTextDisplay(Map<String, dynamic> current) {
    final title = current['title']?.toString() ?? '';
    final body = current['body']?.toString() ?? current['content']?.toString() ?? '';

    final List<Color> welcomeCardGradient = [
      const Color(0xFF283593),
      const Color(0xFF3F51B5),
    ];

    return buildActivityContainer(
      key: const ValueKey("text"),
      gradientColors: welcomeCardGradient,
      shadowColor: Colors.redAccent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            Text(title, style: kVibrantTitleStyle),
          const SizedBox(height: 6),
          Text(body, style: kVibrantBodyStyle),
        ],
      ),
    );
  }

  Widget _buildPoll(Map<String, dynamic> current) {
    final question = current['question']?.toString() ?? '';
    final options = List<String>.from(current['options'] ?? []);
    final List<Color> optionColors = [
      refinedGreenStart,
      refinedGreenEnd,
      const Color(0xFF43A047),
      const Color(0xFF4CAF50),
      refinedGreenEnd,
    ];

    return Container(
      key: const ValueKey("poll"),
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: refinedGreenStart.withOpacity(0.8),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (question.isNotEmpty)
            Text(
              question,
              style: kActivityTitleStyle.copyWith(color: Colors.black),
            ),
          const SizedBox(height: 10),
          ...options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: ElevatedButton(
                onPressed: _handleActivityCompleted,
                style: ElevatedButton.styleFrom(
                  backgroundColor: optionColors[index % optionColors.length],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                ),
                child: Text(option, style: const TextStyle(fontWeight: FontWeight.w500)),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTip(Map<String, dynamic> current) {
    final title = current['title']?.toString() ?? '';
    final body = current['body']?.toString() ?? '';

    return buildActivityContainer(
      key: const ValueKey("tip"),
      gradientColors: [pastelYellow.withOpacity(0.95), pastelYellow],
      shadowColor: Colors.tealAccent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            Text(title, style: kActivityTitleStyle.copyWith(color: Colors.deepOrange)),
          const SizedBox(height: 10),
          Text(body, style: kActivityBodyStyle),
        ],
      ),
    );
  }

  Widget _buildMessage(Map<String, dynamic> current) {
    final text = current['text']?.toString() ?? '';

    return buildActivityContainer(
      key: const ValueKey("message"),
      gradientColors: [vibrantPink.withOpacity(0.95), vibrantPink],
      shadowColor: Colors.amberAccent,
      child: AnimatedTextKit(
        isRepeatingAnimation: false,
        animatedTexts: [
          TypewriterAnimatedText(
            text,
            textStyle: kVibrantMessageStyle,
            speed: const Duration(milliseconds: 40),
            cursor: '▌',
          ),
        ],
      ),
    );
  }

  Widget _buildSpeakingPrompt(Map<String, dynamic> current) {
    final prompt = current['prompt']?.toString() ?? '';
    final audioPath = current['audioPath']?.toString() ?? '';
    final audioSupport = current['audioSupport'] == true;

    final List<Color> speakingPromptGradient = [
      const Color(0xFF4A148C),
      const Color(0xFF7B1FA2),
    ];

    return buildActivityContainer(
      key: const ValueKey("speaking_prompt"),
      gradientColors: speakingPromptGradient,
      shadowColor: Colors.black45,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("🗣️ Try Saying This:", style: kSpeakingPromptTitleStyleNew),
          const SizedBox(height: 8),
          DefaultTextStyle(
            style: const TextStyle(fontSize: 16, color: Colors.white),
            child: buildTextWithUserName(prompt, align: TextAlign.start),
          ),
          if (audioSupport) ...[
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                await _audioPlayer.stop();
                if (audioPath.trim().isNotEmpty) {
                  final relative = audioPath.startsWith('assets/')
                      ? audioPath.replaceFirst('assets/', '')
                      : audioPath;
                  debugPrint("🔊 Attempting speaking_prompt audio: $relative");
                  await _audioPlayer.play(AssetSource(relative));
                } else {
                  debugPrint("❌ No valid speaking_prompt audioPath found.");
                }
              },
              icon: const Icon(Icons.mic, size: 24),
              label: const Text("Listen to Example", style: TextStyle(fontSize: 16)),
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

  Widget _buildBadge(Map<String, dynamic> current) {
    final title = current['title']?.toString() ?? '';
    final description = current['description']?.toString() ?? '';
    final animation = current['animation']?.toString();

    return buildActivityContainer(
      key: const ValueKey("badge"),
      gradientColors: [vibrantPink.withOpacity(0.95), vibrantPink],
      shadowColor: Colors.pinkAccent,
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
          Text(title, style: kVibrantTitleStyle),
          const SizedBox(height: 6),
          Text(
            description,
            style: kVibrantBodyStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRoleplay(Map<String, dynamic> current) {
    final text = current['text']?.toString() ?? '';
    return buildActivityContainer(
      key: const ValueKey("roleplay"),
      gradientColors: [
        refinedGreenStart.withOpacity(0.95),
        refinedGreenEnd,
      ],
      shadowColor: Colors.orangeAccent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("🤝 Role-Play Time!", style: kVibrantTitleStyle),
          const SizedBox(height: 10),
          Text(text, style: kVibrantBodyStyle),
        ],
      ),
    );
  }
}
