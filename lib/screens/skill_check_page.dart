import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

enum QuestionType { audio, image }

class SkillCheckPage extends StatefulWidget {
  final String userName;
  final String languagePreference;
  final String gender;
  final int age;
  final List<String> recommendedCourses;

  // NEW: so we can pass it from routeSkillCheck -> ProfilingResult
  final String userLevel;

  const SkillCheckPage({
    Key? key,
    required this.userName,
    required this.languagePreference,
    required this.gender,
    required this.age,
    required this.recommendedCourses,
    required this.userLevel, // <--- ADDED
  }) : super(key: key);

  @override
  State<SkillCheckPage> createState() => _SkillCheckPageState();
}

class _SkillCheckPageState extends State<SkillCheckPage> {
  final List<SkillCheckQuestion> _questions = [
    // UPDATED: Changed audioAsset, questionText, and options
    SkillCheckQuestion(
      questionType: QuestionType.audio,
      questionText: "🎧 Listen carefully and tell us what’s happening in the audio.",
      audioAsset: 'assets/sounds/lesson_audio/goodbye_see_you.mp3',
      options: [
        "This is a farewell phrase wishing someone well.",
        "This is asking for directions politely.",
        "This means 'I like apples.'",
        "It's a short greeting for 'Hello, how are you?'",
      ],
      correctAnswerIndex: 0, // 'farewell phrase' is correct
    ),
    SkillCheckQuestion(
      questionType: QuestionType.image,
      questionText: 'What’s happening in this picture?',
      imageAsset: 'assets/images/help_request_scene_16x9.png',
      options: [
        'They are greeting each other in an office',
        'Asking directions at an Airport', // Correct answer
        'A family reunion at home',
        'They are ordering coffee in a cafe',
      ],
      correctAnswerIndex: 1,
    ),
  ];

  int _currentQuestionIndex = 0;
  int _score = 0;
  int? _selectedOptionIndex;
  bool _hasAnswered = false;

  /// Mentor expression (PNG)
  String _mentorAsset = 'assets/images/mentor_expressions/mentor_thinking_upper.png';

  /// Audio player for question audio
  final AudioPlayer _audioPlayer = AudioPlayer();

  /// Lottie overlay for feedback
  OverlayEntry? _lottieOverlay;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  /// Play short audio snippet from "assets/sounds/lesson_audio/..."
  Future<void> _playAudioClip(String path) async {
    try {
      // Stop any previous playback, then play new
      await _audioPlayer.stop();
      await _audioPlayer.play(
        AssetSource(path.replaceFirst('assets/sounds/', 'lesson_audio/')),
      );
    } catch (e) {
      debugPrint('🔈 Play error: $e');
    }
  }

  /// Show correct/incorrect Lottie feedback overlay
  void _showFeedback(bool correct) {
    _lottieOverlay?.remove();
    final anim = correct
        ? 'assets/animations/activity_correct.json'
        : 'assets/animations/activity_wrong.json';

    _lottieOverlay = OverlayEntry(builder: (_) {
      return Center(
        child: Lottie.asset(anim, width: 160, height: 160, repeat: false),
      );
    });
    Overlay.of(context)!.insert(_lottieOverlay!);
    Future.delayed(const Duration(seconds: 2), () {
      _lottieOverlay?.remove();
      _lottieOverlay = null;
    });
  }

  /// Check answer logic
  Future<void> _checkAnswer() async {
    final question = _questions[_currentQuestionIndex];

    // If no answer selected, prompt user
    if (_selectedOptionIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an answer!')),
      );
      return;
    }

    final isCorrect = _selectedOptionIndex == question.correctAnswerIndex;
    if (isCorrect) {
      _score++;
      _mentorAsset = 'assets/images/mentor_expressions/mentor_encouraging_upper.png';
      await _audioPlayer.play(AssetSource('sounds/correct.mp3'));
    } else {
      _mentorAsset = 'assets/images/mentor_expressions/mentor_sad_upper.png';
      await _audioPlayer.play(AssetSource('sounds/incorrect.mp3'));
    }

    setState(() => _hasAnswered = true);
    _showFeedback(isCorrect);
  }

  /// Move to next question or finalize
  void _next() {
    // If on last question, navigate to profilingResult
    if (_currentQuestionIndex == _questions.length - 1) {
      context.go(
        '/profilingResult',
        extra: {
          'score': _score,
          'totalQuestions': _questions.length,
          'userName': widget.userName,
          'languagePreference': widget.languagePreference,
          'gender': widget.gender,
          'age': widget.age,
          'recommendedCourses': widget.recommendedCourses,
          // Pass the userLevel from the skill check page
          'userLevel': widget.userLevel,
        },
      );
      return;
    }

    // Otherwise, go to next question
    setState(() {
      _currentQuestionIndex++;
      _selectedOptionIndex = null;
      _hasAnswered = false;
      _mentorAsset = 'assets/images/mentor_expressions/mentor_thinking_upper.png';
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestionIndex];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB3E5FC), Color(0xFFE1F5FE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Animated mentor image
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(scale: animation, child: child),
                  );
                },
                child: Image.asset(
                  _mentorAsset,
                  key: ValueKey<String>(_mentorAsset),
                  width: 160,
                  height: 160,
                ),
              ),
              const SizedBox(height: 8),

              // Question text
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  question.questionText,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),

              // If audio question, show play button
              if (question.questionType == QuestionType.audio &&
                  question.audioAsset != null)
                ElevatedButton.icon(
                  icon: const Icon(Icons.play_circle_fill),
                  label: const Text('Play Audio'),
                  onPressed: () => _playAudioClip(question.audioAsset!),
                ),

              // If image question, show the image
              if (question.questionType == QuestionType.image &&
                  question.imageAsset != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Image.asset(
                    question.imageAsset!,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),

              const SizedBox(height: 10),

              // Multiple-choice options
              ...question.options.asMap().entries.map((e) {
                final idx = e.key;
                final txt = e.value;
                final isSelected = (_selectedOptionIndex == idx);

                return GestureDetector(
                  onTap: () => setState(() => _selectedOptionIndex = idx),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 16,
                    ),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.blueAccent.withOpacity(0.2)
                          : Colors.white,
                      border: Border.all(
                        color: isSelected ? Colors.blueAccent : Colors.grey.shade300,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      txt,
                      style: TextStyle(
                        fontSize: 16,
                        color: isSelected ? Colors.blueAccent.shade700 : Colors.black87,
                      ),
                    ),
                  ),
                );
              }),

              const Spacer(),

              // Check or Next button
              if (!_hasAnswered)
                ElevatedButton(
                  onPressed: _checkAnswer,
                  child: const Text('Check Answer'),
                )
              else
                ElevatedButton(
                  onPressed: _next,
                  child: Text(
                    _currentQuestionIndex == _questions.length - 1
                        ? 'Show My Results'
                        : 'Next Question',
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class SkillCheckQuestion {
  final QuestionType questionType;
  final String questionText;
  final String? audioAsset;
  final String? imageAsset;
  final List<String> options;
  final int correctAnswerIndex;

  SkillCheckQuestion({
    required this.questionType,
    required this.questionText,
    this.audioAsset,
    this.imageAsset,
    required this.options,
    required this.correctAnswerIndex,
  });
}
