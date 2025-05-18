import 'dart:async';
import 'dart:convert'; // For jsonDecode/jsonEncode
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http; // For direct HTTP requests

import 'package:fluentedge_app/constants.dart';
import 'package:fluentedge_app/widgets/animated_mentor_widget.dart';
import 'package:fluentedge_app/services/api_service.dart'; // If you still want to use ApiService for something

// ✅ Audio & Lottie
import 'package:audioplayers/audioplayers.dart';
import 'package:lottie/lottie.dart';

class ProfilingChatPage extends ConsumerStatefulWidget {
  const ProfilingChatPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfilingChatPage> createState() => _ProfilingChatPageState();
}

class _ProfilingChatPageState extends ConsumerState<ProfilingChatPage> {
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _chat = [];

  int _currentStep = 0;
  bool _showTip = false;
  bool _isSubmitting = false;

  // Controls when to show typing indicator & question options
  bool _showTypingIndicator = false;
  bool _showOptions = false;

  // Audio player for intros, tips, encouragement
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _answerCount = 0; // track how many answers have been selected

  // We keep the progress bar
  final String _progressBar = 'assets/animations/profiling_progress_bar.json';

  // Throttle tip audio so it plays only once per question
  bool _tipAudioPlayed = false;

  /// ===============================
  /// English vs. Hindi Question Sets
  /// ===============================
  final List<_ChatQuestion> _englishQuestions = [
    _ChatQuestion(
      question: "How confident are you in speaking English?",
      key: "comfort_level",
      options: ["Beginner", "Intermediate", "Advanced"],
      mentorExpression: "mentor_analytical_upper.png",
    ),
    _ChatQuestion(
      question: "How often do you want to practice?",
      key: "practice_frequency",
      options: ["Daily", "Few times/week", "Once a week"],
      mentorExpression: "mentor_thinking_upper.png",
    ),
    _ChatQuestion(
      question: "What topics interest you most?",
      key: "interests",
      options: ["Movies", "Travel", "Family", "Work", "Culture"],
      mentorExpression: "mentor_encouraging_upper.png",
    ),
    _ChatQuestion(
      question: "What's your biggest challenge?",
      key: "challenges",
      options: ["Pronunciation", "Vocabulary", "Confidence", "Grammar"],
      mentorExpression: "mentor_reassure_upper.png",
    ),
  ];

  final List<_ChatQuestion> _hindiQuestions = [
    _ChatQuestion(
      question: "अंग्रेज़ी बोलने में आपका आत्मविश्वास कैसा है?",
      key: "comfort_level",
      options: ["शुरुआती", "मध्यम", "उन्नत"],
      mentorExpression: "mentor_analytical_upper.png",
    ),
    _ChatQuestion(
      question: "आप कितनी बार अभ्यास करना चाहते हैं?",
      key: "practice_frequency",
      options: ["रोज़ाना", "सप्ताह में कुछ बार", "सप्ताह में एक बार"],
      mentorExpression: "mentor_thinking_upper.png",
    ),
    _ChatQuestion(
      question: "आपको कौन-से विषय सबसे ज़्यादा पसंद हैं?",
      key: "interests",
      options: ["फ़िल्में", "यात्रा", "परिवार", "काम", "संस्कृति"],
      mentorExpression: "mentor_encouraging_upper.png",
    ),
    _ChatQuestion(
      question: "आपकी सबसे बड़ी चुनौती क्या है?",
      key: "challenges",
      options: ["उच्चारण", "शब्दावली", "आत्मविश्वास", "व्याकरण"],
      mentorExpression: "mentor_reassure_upper.png",
    ),
  ];

  /// We'll dynamically choose which question set to use based on language
  List<_ChatQuestion> get _activeQuestions {
    final isHindi = _isAppLanguageHindi();
    return isHindi ? _hindiQuestions : _englishQuestions;
  }

  final Map<String, dynamic> _responses = {};

  @override
  void initState() {
    super.initState();
    // 1) Immediately play intro audio
    _playAudioIntro();

    // Start first question
    _addMentorQuestion();
    // Start tip timer
    _startTipTimer();
  }

  /// Utility to check if app language is Hindi
  bool _isAppLanguageHindi() {
    // We read from the user box or settings box
    // to see if the user selected 'हिंदी'.
    // For consistency, let's use 'settings' box:
    // or we can read from user box also.
    final userBox = Hive.box(kHiveBoxSettings);
    final languagePref = userBox.get(kHiveKeyLanguagePreference) ?? 'English';
    return (languagePref == 'हिंदी');
  }

  /// 2) Determine language & play audio_profiling_intro_[lang].mp3
  Future<void> _playAudioIntro() async {
    // We open the user box
    final userBox = await Hive.openBox('user');
    final languagePref = userBox.get(kHiveKeyLanguagePreference) ?? 'English';
    final isHindi = (languagePref == 'हिंदी');

    final fileName = isHindi
        ? 'audio_profiling_intro_hi.mp3'
        : 'audio_profiling_intro_en.mp3';

    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(fileName));
    } catch (e) {
      debugPrint('❌ Could not play intro audio: $e');
    }
  }

  /// 3) After 6 seconds idle → show tip + play tip audio if not already played
  void _startTipTimer() {
    Future.delayed(const Duration(seconds: 6), () {
      if (mounted && _responses.length == _currentStep) {
        setState(() => _showTip = true);
        if (!_tipAudioPlayed) {
          _tipAudioPlayed = true;
          _playAudioTip();
        }
      }
    });
  }

  // Resets tip audio throttle each time user picks an answer
  void _resetTipAudioThrottle() {
    _tipAudioPlayed = false;
  }

  // 4) Play "audio_tip_en.mp3" or "audio_tip_hi.mp3"
  Future<void> _playAudioTip() async {
    final settingsBox = await Hive.openBox(kHiveBoxSettings);
    final languagePref = settingsBox.get(kHiveKeyLanguagePreference) ?? 'English';
    final isHindi = (languagePref == 'हिंदी');

    final fileName = isHindi ? 'audio_tip_hi.mp3' : 'audio_tip_en.mp3';

    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(fileName));
    } catch (e) {
      debugPrint('❌ Could not play tip audio: $e');
    }
  }

  // 5) Add next question from mentor
  void _addMentorQuestion() {
    final questions = _activeQuestions;
    if (_currentStep < questions.length) {
      _chat.add({
        'type': 'mentor',
        'text': questions[_currentStep].question,
        'expression': questions[_currentStep].mentorExpression,
      });

      setState(() {
        _showTip = false;
        _showTypingIndicator = false;
        _showOptions = false;
        _tipAudioPlayed = false; // reset tip throttle for new question
      });

      _scrollToBottom();

      // Show typing indicator briefly before question
      _showTypingIndicator = true;

      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        setState(() {
          _showTypingIndicator = false;
          _showOptions = true;
        });
        _scrollToBottom();
      });
    }
  }

  // 6) On user answer
  void _onOptionSelected(String option) {
    final questions = _activeQuestions;

    final currentKey = questions[_currentStep].key;
    _responses[currentKey] = option;

    // Show user answer in chat
    _chat.add({'type': 'user', 'text': option});
    _scrollToBottom();

    setState(() {
      _showTip = false;
      _currentStep++;
      _answerCount++;
    });

    // reset tip throttle
    _resetTipAudioThrottle();

    // Encouragement after every 2 answers
    if (_answerCount % 2 == 0) {
      _playAudioEncouragement();
    }

    // If more questions remain, next question; else submit
    if (_currentStep < questions.length) {
      _addMentorQuestion();
      _startTipTimer();
    } else {
      _submitProfileAndContinue(); // final step
    }
  }

  // Encouragement after every 2 answers
  Future<void> _playAudioEncouragement() async {
    final settingsBox = await Hive.openBox(kHiveBoxSettings);
    final languagePref = settingsBox.get(kHiveKeyLanguagePreference) ?? 'English';
    final isHindi = (languagePref == 'हिंदी');

    final fileName = isHindi ? 'audio_encourage_hi.mp3' : 'audio_encourage_en.mp3';

    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(fileName));
    } catch (e) {
      debugPrint('❌ Could not play encouragement audio: $e');
    }
  }

  // 7) Submits final user responses & obtains recommended courses,
  //    then navigates to SkillCheck page (not directly to ProfilingResult).
  Future<void> _submitProfileAndContinue() async {
    setState(() => _isSubmitting = true);

    try {
      // 1) Collect user info from Hive
      final settingsBox = await Hive.openBox(kHiveBoxSettings);
      final userId = settingsBox.get('user_id') ?? '';
      final userName = settingsBox.get(kHiveKeyUserName) ?? '';
      final userEmail = settingsBox.get(kHiveKeyEmail) ?? '';
      final userGender = settingsBox.get(kHiveKeyGender) ?? '';
      final userAge = settingsBox.get(kHiveKeyAgeGroup) ?? '0';
      final userLang = settingsBox.get(kHiveKeyLanguagePreference) ?? 'English';

      // Fields from chat answers
      final comfortLevel = _responses['comfort_level'] ?? '';
      final practiceFreq = _responses['practice_frequency'] ?? '';
      final userInterests = _responses['interests'] ?? '';
      final userChallenges = _responses['challenges'] ?? '';

      // 2) POST /user/profile?user_id=xyz (with user_id as query param)
      final profileBody = {
        'name': userName,
        'email': userEmail,
        'age': int.tryParse(userAge.toString()) ?? 0,
        'gender': userGender,
        'comfort_level': comfortLevel,
        'practice_frequency': practiceFreq,
        // must be a list, not a single string
        'interests': [userInterests],
        'challenges': userChallenges,
        // add proficiency_score
        'proficiency_score': 70,
      };

      final profileUri = Uri.parse('${ApiConfig.local}/api/v1/user/profile?user_id=$userId');
      final profileRes = await http.post(
        profileUri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(profileBody),
      );

      if (profileRes.statusCode != 200) {
        debugPrint('❌ profileRes failed: ${profileRes.body}');
        throw Exception('Profile POST failed');
      }
      debugPrint('✅ Profile saved: ${profileRes.body}');

      // 3) GET /user/{id}/recommendations
      final recRes = await http.get(
        Uri.parse('${ApiConfig.local}/api/v1/user/$userId/recommendations'),
      );
      if (recRes.statusCode != 200) {
        debugPrint('❌ recRes failed: ${recRes.body}');
        throw Exception('Recommendations GET failed');
      }
      final recData = jsonDecode(recRes.body) as Map<String, dynamic>;
      final List<String> recommendedCourses =
          List<String>.from(recData['recommended_courses'] ?? []);

      // === retrieve the user_level from recData
      final String userLevel = recData['user_level'] ?? 'beginner';
      debugPrint("✅ userLevel from backend: $userLevel");

      // 4) final step: go to SkillCheck
      context.go(
        routeSkillCheck,
        extra: {
          'userName': userName,
          'languagePreference': userLang,
          'gender': userGender,
          'age': int.tryParse(userAge) ?? 0,
          'recommendedCourses': recommendedCourses,
          'userLevel': userLevel,
        },
      );

    } catch (e) {
      debugPrint('❌ Full profile submission & rec fetch failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to complete profiling. Please try again.')),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  /// Scrolls the chat list to the bottom
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 150,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  /// The ratio for the Lottie progress bar
  double get progressRatio {
    final questions = _activeQuestions;
    if (questions.isEmpty) return 0.0;
    return _currentStep / questions.length;
  }

  @override
  void dispose() {
    // Dispose audio player
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final questions = _activeQuestions;

    // If we've exhausted all steps, fallback expression:
    final currentExpression = _currentStep < questions.length
        ? questions[_currentStep].mentorExpression
        : 'mentor_wave_smile_full.png';

    return WillPopScope(
      onWillPop: () async {
        final result = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Almost done!"),
            content: const Text("Are you sure you want to exit profiling?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Stay"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Exit"),
              ),
            ],
          ),
        );
        return result ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Let's Personalize Your Journey"),
          backgroundColor: kPrimaryBlue,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 4,
          shadowColor: Colors.black54,
        ),
        // Color-coded gradient background
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE1F5FE), Color(0xFFBBDEFB)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              // Step progress bar
              SizedBox(
                height: 140,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Lottie.asset(
                    _progressBar,
                    repeat: false,
                    controller: AlwaysStoppedAnimation(progressRatio),
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // The chat area
              Expanded(
                child: Column(
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 600),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(scale: animation, child: child),
                        );
                      },
                      child: AnimatedMentorWidget(
                        key: ValueKey<String>(currentExpression),
                        expressionName: currentExpression,
                        size: 150,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: _chat.length,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemBuilder: (context, index) {
                          final entry = _chat[index];
                          final isMentor = entry['type'] == 'mentor';
                          return Align(
                            alignment:
                                isMentor ? Alignment.centerLeft : Alignment.centerRight,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              padding: const EdgeInsets.all(12),
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.75,
                              ),
                              decoration: BoxDecoration(
                                color: isMentor ? Colors.white : Colors.blue[100],
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: isMentor
                                        ? Colors.grey.withOpacity(0.3)
                                        : Colors.blue.withOpacity(0.2),
                                    blurRadius: 6,
                                    offset: const Offset(2, 3),
                                  ),
                                ],
                              ),
                              child: Text(
                                entry['text'],
                                style: const TextStyle(fontSize: 14, height: 1.3),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // If we are submitting final data, show spinner
              if (_isSubmitting)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: CircularProgressIndicator(),
                ),

              // If not done with questions...
              if (_currentStep < questions.length && !_isSubmitting) ...[
                if (_showTypingIndicator)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: _LottieTypingIndicator(),
                  ),
                if (_showOptions)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: questions[_currentStep]
                          .options
                          .map((option) => _buildAnimatedOptionButton(option))
                          .toList(),
                    ),
                  ),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Creates an option button with a small scale animation
  Widget _buildAnimatedOptionButton(String optionText) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 1.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: ElevatedButton(
            onPressed: () => _onOptionSelected(optionText),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: kPrimaryBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: kPrimaryBlue),
              ),
              elevation: 2,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
              child: Text(
                optionText,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Lottie typing indicator
class _LottieTypingIndicator extends StatelessWidget {
  const _LottieTypingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Replace with your actual Lottie asset path
    return SizedBox(
      width: 60,
      height: 40,
      child: Lottie.asset(
        'assets/animations/typing_indicator_dots.json',
        repeat: true,
      ),
    );
  }
}

// A small chat question model
class _ChatQuestion {
  final String question;
  final String key;
  final List<String> options;
  final String mentorExpression;

  const _ChatQuestion({
    required this.question,
    required this.key,
    required this.options,
    required this.mentorExpression,
  });
}
