import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:fluentedge_app/services/api_service.dart';
import 'package:fluentedge_app/localization/app_localizations.dart';
import 'package:fluentedge_app/screens/smart_course_recommendation.dart';

class QuestionnairePage extends StatefulWidget {
  final String userName;
  final String languagePreference;
  final void Function(String gender, int age)? onGenderAndAgeSubmitted;

  const QuestionnairePage({
    super.key,
    required this.userName,
    required this.languagePreference,
    this.onGenderAndAgeSubmitted,
  });

  @override
  State<QuestionnairePage> createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> with SingleTickerProviderStateMixin {
  int _step = 0;
  late AnimationController _controller;
  final player = AudioPlayer();

  String? purpose, englishLevel, biggestChallenge, learningStyle, dailyTime, learningTimeline, age, gender;
  late AppLocalizations localizations;

  final emojis = ["🚀", "🌍", "💼", "📚", "🤓", "🥇", "🕰️", "👨‍🎓"];
  late final List<String> questions;
  late final List<List<String>> answerSets;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    player.dispose();
    super.dispose();
  }

  void _handleNext(String selectedValue) async {

    setState(() {
      switch (_step) {
        case 0: purpose = selectedValue; break;
        case 1: englishLevel = selectedValue; break;
        case 2: biggestChallenge = selectedValue; break;
        case 3: learningStyle = selectedValue; break;
        case 4: dailyTime = selectedValue; break;
        case 5: learningTimeline = selectedValue; break;
        case 6: age = selectedValue; break;
        case 7: gender = selectedValue; break;
      }

      if (_step < 7) {
        _step++;
        _controller.forward(from: 0); // Restart fade-in
      } else {
        _submitUserData();
      }
    });
  }

  Future<void> _submitUserData() async {
    localizations = AppLocalizations.of(context) ?? AppLocalizations(const Locale('en'));
    final parsedAge = int.tryParse(age ?? '0') ?? 0;

    try {
      final response = await ApiService.saveUserResponses(
        name: widget.userName,
        motivation: purpose ?? '',
        englishLevel: englishLevel ?? '',
        learningStyle: learningStyle ?? '',
        difficultyArea: biggestChallenge ?? '',
        dailyTime: dailyTime ?? '',
        learningTimeline: learningTimeline ?? '',
        age: parsedAge,
        gender: gender ?? '',
      );

      final recommendedCourses = (response['recommended_courses'] as List?)?.cast<String>() ?? ['Smart Daily Conversations'];
      widget.onGenderAndAgeSubmitted?.call(gender ?? '', parsedAge);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SmartCourseRecommendationPage(
            userName: widget.userName,
            languagePreference: widget.languagePreference,
            gender: gender ?? '',
            age: parsedAge,
            recommendedCourses: recommendedCourses,
          ),
        ),
      );
    } catch (e) {
      debugPrint("❌ Submission error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❗ ${localizations.nameRequiredError}")),
      );
    }
  }

  Widget _buildOption(String option) {
    return ElevatedButton(
      onPressed: () => _handleNext(option),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1976D2),
        side: const BorderSide(color: Color(0xFF1976D2), width: 1.3),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 2,
      ),
      child: Text(option, textAlign: TextAlign.center),
    );
  }

  Widget _buildProgressBar() {
    final colors = [Colors.deepPurple, Colors.orange, Colors.green, Colors.pink, Colors.indigo, Colors.teal, Colors.amber, Colors.blue];
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: colors[_step % colors.length].withOpacity(0.5), blurRadius: 6)],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: LinearProgressIndicator(
          value: (_step + 1) / 8,
          valueColor: AlwaysStoppedAnimation<Color>(colors[_step % colors.length]),
          backgroundColor: Colors.blue.shade100,
          minHeight: 8,
        ),
      ),
    );
  }

  Widget _buildAnimatedStep(String question, List<String> options) {
    return FadeTransition(
      opacity: _controller,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProgressBar(),
          const SizedBox(height: 16),
          Text(
            widget.languagePreference == 'हिंदी' ? "कदम ${_step + 1} / 8" : "Step ${_step + 1} of 8",
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 10),

          /// ✅ Typing animation
          AnimatedTextKit(
            key: ValueKey(_step),
            totalRepeatCount: 1,
            isRepeatingAnimation: false,
            animatedTexts: [
              TyperAnimatedText(
                "${emojis[_step]}  $question",
                textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                speed: const Duration(milliseconds: 35),
              ),
            ],
          ),

          const SizedBox(height: 24),
          Wrap(spacing: 12, runSpacing: 12, children: options.map(_buildOption).toList()),
          const SizedBox(height: 20),
          Center(
            child: TextButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/coursesDashboard'),
              icon: const Icon(Icons.explore, color: Color(0xFF1976D2)),
              label: Text(
                widget.languagePreference == 'हिंदी' ? "प्रश्न छोड़ें और कोर्स देखें" : "Explore All Courses",
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1976D2)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepUI() {
    localizations = AppLocalizations.of(context) ?? AppLocalizations(const Locale('en'));
    final isHindi = widget.languagePreference == 'हिंदी';

    final List<String> questions = isHindi
        ? [
            "अभी अपने इंग्लिश सुधारने का मुख्य कारण क्या है?",
            "आपकी वर्तमान इंग्लिश लेवल क्या है?",
            "इंग्लिश सीखने में आपकी सबसे बड़ी चुनौती क्या है?",
            "आप इंग्लिश का अभ्यास किस तरह करना पसंद करते हैं?",
            "प्रति दिन आप कितना समय दे सकते हैं?",
            "आप कब तक सुधार देखना चाहते हैं?",
            "आप किस आयु वर्ग में हैं?",
            "आपका लिंग क्या है?"
          ]
        : [
            "What is your main reason for improving your English right now?",
            "Which best describes your current English level?",
            "What’s your biggest challenge in learning English so far?",
            "How do you prefer to study or practice your English?",
            "How much time can you dedicate each day to practicing?",
            "By when do you want to see noticeable improvement?",
            "What’s your age range?",
            "What’s your gender?"
          ];

    final List<List<String>> answerSets = isHindi
        ? [
            ['नौकरी / इंटरव्यू की तैयारी', 'यात्रा', 'परिवार', 'स्कूल / कॉलेज', 'पब्लिक स्पीकिंग', 'सोशल मीडिया', 'दफ्तर / बिज़नेस'],
            ['बिगिनर', 'इंटरमीडिएट', 'एडवांस्ड'],
            ['ग्रामर', 'शब्दावली', 'उच्चारण', 'आत्मविश्वास', 'स्पीकिंग स्पीड', 'सुनना-समझना'],
            ['पढ़ना', 'ऑडियो/वीडियो', 'इंटरएक्शन', 'लिखित अभ्यास'],
            ['15 मिनट से कम', '15-30 मिनट', '30-60 मिनट', '1 घंटे से अधिक'],
            ['1 महीने', '3 महीने', '6 महीने', 'कोई डेडलाइन नहीं'],
            ['18 से कम', '18-25', '26-35', '36-45', '46+'],
            ['पुरुष', 'महिला', 'अन्य'],
          ]
        : [
            ['Job / Interview', 'Travel', 'Family', 'School / College', 'Public Speaking', 'Social Media', 'Office Work'],
            ['Beginner', 'Intermediate', 'Advanced'],
            ['Grammar', 'Vocabulary', 'Pronunciation', 'Confidence', 'Fluency', 'Listening'],
            ['Reading', 'Listening', 'Speaking', 'Writing'],
            ['Under 15 min', '15-30 min', '30-60 min', 'More than 1 hr'],
            ['1 month', '3 months', '6 months', 'No deadline'],
            ['Under 18', '18-25', '26-35', '36-45', '46+'],
            ['Male', 'Female', 'Other'],
          ];

    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Opacity(
            opacity: 0.5,
            child: Center(
              child: Lottie.asset('assets/animations/ai_mentor_thinking.json', width: 200),
            ),
          ),
        ),
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          child: _buildAnimatedStep(questions[_step], answerSets[_step]),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FB),
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          widget.languagePreference == 'हिंदी' ? "📝 आपकी इंग्लिश यात्रा" : "📝 Your English Journey",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: _buildStepUI(),
    );
  }
}
