import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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

class _QuestionnairePageState extends State<QuestionnairePage> {
  int _step = 0;

  String? motivation;
  String? englishLevel;
  String? learningStyle;
  String? difficultyArea;
  String? dailyTime;
  String? learningTimeline;
  String? age;
  String? gender;

  late AppLocalizations localizations;

  List<String> get localizedMotivations =>
      localizations.getMotivationOptions(widget.languagePreference);
  List<String> get localizedLevels =>
      localizations.getEnglishLevelOptions(widget.languagePreference);
  List<String> get localizedStyles =>
      localizations.getLearningStyleOptions(widget.languagePreference);
  List<String> get localizedDifficulties =>
      localizations.getDifficultyOptions(widget.languagePreference);
  List<String> get localizedTimeOptions =>
      localizations.getTimeOptions(widget.languagePreference);
  List<String> get localizedTimelineOptions =>
      localizations.getTimelineOptions(widget.languagePreference);

  void _handleNext(String selectedValue) {
    switch (_step) {
      case 0:
        motivation = selectedValue;
        break;
      case 1:
        englishLevel = selectedValue;
        break;
      case 2:
        learningStyle = selectedValue;
        break;
      case 3:
        difficultyArea = selectedValue;
        break;
      case 4:
        dailyTime = selectedValue;
        break;
      case 5:
        learningTimeline = selectedValue;
        break;
      case 6:
        age = selectedValue;
        break;
      case 7:
        gender = selectedValue;
        break;
    }

    if (_step < 7) {
      setState(() => _step++);
    } else {
      Future.microtask(() => _submitUserData());
    }
  }

  Future<void> _submitUserData() async {
    try {
      final parsedAge = int.tryParse(age ?? '0') ?? 0;

      // 🔄 Send API request
      final response = await ApiService.saveUserResponses(
        name: widget.userName,
        motivation: motivation ?? '',
        englishLevel: englishLevel ?? '',
        learningStyle: learningStyle ?? '',
        difficultyArea: difficultyArea ?? '',
        dailyTime: dailyTime ?? '',
        learningTimeline: learningTimeline ?? '',
        age: parsedAge,
        gender: gender ?? '',
      );

      // ✅ Extract dynamic recommendedCourses from API
      final List<String> recommendedCourses =
          (response['recommended_courses'] as List?)?.cast<String>() ??
              ['Smart Daily Conversations'];

      // ✅ Notify parent about gender & age
      widget.onGenderAndAgeSubmitted?.call(gender ?? '', parsedAge);

      // ✅ Navigate to SmartCourseRecommendationPage with dynamic list
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

  Widget _buildOptions(List<String> options) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: options.map((option) {
        return ElevatedButton(
          onPressed: () => _handleNext(option),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1565C0),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
          child: Text(option, textAlign: TextAlign.center),
        );
      }).toList(),
    );
  }

  Widget _buildStepUI() {
    localizations =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('en'));
    final theme = Theme.of(context).textTheme;

    String getQuestion() {
      switch (_step) {
        case 0:
          return localizations.getStep1Question(widget.languagePreference);
        case 1:
          return localizations.getStep2Question(widget.languagePreference);
        case 2:
          return localizations.getStep3Question(widget.languagePreference);
        case 3:
          return localizations.getStep4Question(widget.languagePreference);
        case 4:
          return localizations.getStep5Question(widget.languagePreference);
        case 5:
          return localizations.getStep6Question(widget.languagePreference);
        case 6:
          return localizations.getStep7Question(widget.languagePreference);
        case 7:
          return localizations.getStep8Question(widget.languagePreference);
        default:
          return '';
      }
    }

    List<String> getOptions() {
      switch (_step) {
        case 0:
          return localizedMotivations;
        case 1:
          return localizedLevels;
        case 2:
          return localizedStyles;
        case 3:
          return localizedDifficulties;
        case 4:
          return localizedTimeOptions;
        case 5:
          return localizedTimelineOptions;
        case 6:
          return ['Under 18', '18-25', '26-35', '36-45', '46 and above'];
        case 7:
          return ['Male', 'Female', 'Other'];
        default:
          return [];
      }
    }

    String getProgressMessage() {
      switch (_step) {
        case 0:
          return localizations.getProgressStart();
        case 7:
          return localizations.getProgressAlmostDone();
        default:
          return localizations.getProgressKeepGoing();
      }
    }

    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Opacity(
            opacity: 0.45,
            child: Center(
              child: Lottie.asset(
                'assets/animations/ai_mentor_thinking.json',
                width: 250,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          padding:
              const EdgeInsets.only(bottom: 40, left: 16, right: 16, top: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearProgressIndicator(
                value: (_step + 1) / 8,
                color: const Color(0xFF1565C0),
                backgroundColor: Colors.blue.shade100,
              ),
              const SizedBox(height: 8),
              Text(
                getProgressMessage(),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                  color: Color(0xFF0D47A1),
                ),
              ),
              const SizedBox(height: 20),
              Text("Hi ${widget.userName}! 👋",
                  style: theme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600, fontSize: 16)),
              const SizedBox(height: 10),
              Text(getQuestion(),
                  style: theme.titleMedium?.copyWith(
                      fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 20),
              _buildOptions(getOptions()),
              const SizedBox(height: 30),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/coursesDashboard');
                  },
                  child: Text(
                    widget.languagePreference == 'हिंदी'
                        ? "प्रश्न छोड़ें और कोर्स देखें"
                        : "Skip Questions & Explore Courses",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1565C0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FB),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: AppBar(
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
            widget.languagePreference == 'हिंदी'
                ? "📝 आपकी इंग्लिश यात्रा"
                : "📝 Your English Journey",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
      ),
      body: _buildStepUI(),
    );
  }
}
