import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:fluentedge_app/constants.dart';
import 'package:fluentedge_app/services/api_service.dart';
import 'package:fluentedge_app/data/user_state.dart';
import 'package:go_router/go_router.dart';

class QuestionnairePage extends StatefulWidget {
  final String userName;
  final String languagePreference;
  final void Function(String gender, int age, List<String> recommendedCourses) onCompleted;

  const QuestionnairePage({
    super.key,
    required this.userName,
    required this.languagePreference,
    required this.onCompleted,
  });

  @override
  State<QuestionnairePage> createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> with SingleTickerProviderStateMixin {
  int _step = 0;
  late AnimationController _controller;

  String? purpose, englishLevel, biggestChallenge, learningStyle, dailyTime, learningTimeline, age, gender;

  final emojis = ["🚀", "🌍", "💼", "📚", "🤓", "🥇", "🕰️", "👨‍🎓"];

  final questionsEnglish = [
    "What is your main reason for improving your English right now?",
    "Which best describes your current English level?",
    "What’s your biggest challenge in learning English so far?",
    "How do you prefer to study or practice your English?",
    "How much time can you dedicate each day to practicing?",
    "By when do you want to see noticeable improvement?",
    "What’s your age range?",
    "What’s your gender?"
  ];

  final answersEnglish = [
    ['Job / Interview', 'Travel', 'Family', 'School / College', 'Public Speaking', 'Social Media', 'Office Work'],
    ['Beginner', 'Intermediate', 'Advanced'],
    ['Grammar', 'Vocabulary', 'Pronunciation', 'Confidence', 'Fluency', 'Listening'],
    ['Reading', 'Listening', 'Speaking', 'Writing'],
    ['Under 15 min', '15-30 min', '30-60 min', 'More than 1 hr'],
    ['1 month', '3 months', '6 months', 'No deadline'],
    ['Under 18', '18-25', '26-35', '36-45', '46+'],
    ['Male', 'Female', 'Other'],
  ];

  final questionsHindi = [
    "अभी अपने इंग्लिश सुधारने का मुख्य कारण क्या है?",
    "आपकी वर्तमान इंग्लिश लेवल क्या है?",
    "इंग्लिश सीखने में आपकी सबसे बड़ी चुनौती क्या है?",
    "आप इंग्लिश का अभ्यास किस तरह करना पसंद करते हैं?",
    "प्रति दिन आप कितना समय दे सकते हैं?",
    "आप कब तक सुधार देखना चाहते हैं?",
    "आप किस आयु वर्ग में हैं?",
    "आपका लिंग क्या है?"
  ];

  final answersHindi = [
    ['नौकरी / इंटरव्यू की तैयारी', 'यात्रा', 'परिवार', 'स्कूल / कॉलेज', 'पब्लिक स्पीकिंग', 'सोशल मीडिया', 'दफ्तर / बिज़नेस'],
    ['बिगिनर', 'इंटरमीडिएट', 'एडवांस्ड'],
    ['ग्रामर', 'शब्दावली', 'उच्चारण', 'आत्मविश्वास', 'स्पीकिंग स्पीड', 'सुनना-समझना'],
    ['पढ़ना', 'ऑडियो/वीडियो', 'इंटरएक्शन', 'लिखित अभ्यास'],
    ['15 मिनट से कम', '15-30 मिनट', '30-60 मिनट', '1 घंटे से अधिक'],
    ['1 महीने', '3 महीने', '6 महीने', 'कोई डेडलाइन नहीं'],
    ['18 से कम', '18-25', '26-35', '36-45', '46+'],
    ['पुरुष', 'महिला', 'अन्य'],
  ];

  final List<List<Color>> optionGradients = [
    [Colors.deepPurple, Colors.purpleAccent],
    [Colors.blue, Colors.lightBlue],
    [Colors.green, Colors.lightGreen],
    [Colors.teal, Colors.cyan],
    [Colors.orange, Colors.deepOrange],
    [Colors.pink, Colors.redAccent],
    [Colors.indigo, Colors.blueAccent],
    [Colors.amber, Colors.orangeAccent],
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleNext(String selectedValue) {
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
        _controller.forward(from: 0);
      } else {
        _submitUserData();
      }
    });
  }

  Future<void> _submitUserData() async {
    final parsedAge = age != null ? int.tryParse(age!.replaceAll(RegExp(r'\D'), '')) ?? 0 : 0;

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

    final recommendedCourses = response.recommendedCourses.cast<String>().isNotEmpty
        ? response.recommendedCourses.cast<String>()
        : ['Smart Daily Conversations'];

    await UserState.setGender(gender ?? '');
    await UserState.setAge(parsedAge);

    if (mounted) {
      widget.onCompleted(gender ?? '', parsedAge, recommendedCourses);
    }
  }

  Widget _buildOption(String option, int index) {
    final gradient = optionGradients[index % optionGradients.length];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleNext(option),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            child: Row(
              children: [
                const Icon(Icons.arrow_right_alt, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    option,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
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
          AnimatedTextKit(
            key: ValueKey(_step),
            animatedTexts: [
              TyperAnimatedText(
                "${emojis[_step]}  $question",
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: kPrimaryBlue),
              )
            ],
            isRepeatingAnimation: false,
            displayFullTextOnTap: true,
          ),
          const SizedBox(height: 20),
          ...options.asMap().entries.map((entry) => _buildOption(entry.value, entry.key)).toList(),
          const SizedBox(height: 28),
          Center(
            child: TextButton.icon(
              onPressed: () {
                GoRouter.of(context).go(
                  '/coursesDashboard',
                  extra: {'languagePreference': widget.languagePreference},
                );
              },
              icon: const Icon(Icons.explore, color: kPrimaryBlue),
              label: Text(
                widget.languagePreference == 'हिंदी'
                    ? "प्रश्न छोड़ें और कोर्स देखें"
                    : "Skip & Explore All Courses",
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: kPrimaryBlue),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.languagePreference == 'हिंदी'
            ? "📝 आपकी इंग्लिश यात्रा"
            : "📝 Your English Journey"),
        backgroundColor: kPrimaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Lottie.asset(
              'assets/animations/ai_mentor_thinking.json',
              height: 200,
              fit: BoxFit.contain,
              repeat: true,
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 240, 20, 20),
            child: _buildAnimatedStep(
              widget.languagePreference == 'हिंदी'
                  ? questionsHindi[_step]
                  : questionsEnglish[_step],
              widget.languagePreference == 'हिंदी'
                  ? answersHindi[_step]
                  : answersEnglish[_step],
            ),
          ),
        ],
      ),
    );
  }
}
