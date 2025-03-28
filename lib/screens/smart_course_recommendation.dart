import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluentedge_app/localization/app_localizations.dart';

void navigateToSmartRecommendationPage({
  required BuildContext context,
  required String userName,
  required String languagePreference,
  required String gender,
  required int age,
  required List<String> recommendedCourses,
}) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => SmartCourseRecommendationPage(
        userName: userName,
        languagePreference: languagePreference,
        gender: gender,
        age: age,
        recommendedCourses: recommendedCourses,
      ),
    ),
  );
}

class SmartCourseRecommendationPage extends StatefulWidget {
  final String userName;
  final String languagePreference;
  final String gender;
  final int age;
  final List<String> recommendedCourses;

  const SmartCourseRecommendationPage({
    Key? key,
    required this.userName,
    required this.languagePreference,
    required this.gender,
    required this.age,
    required this.recommendedCourses,
  }) : super(key: key);

  @override
  State<SmartCourseRecommendationPage> createState() => _SmartCourseRecommendationPageState();
}

class _SmartCourseRecommendationPageState extends State<SmartCourseRecommendationPage> {
  final FlutterTts flutterTts = FlutterTts();
  bool isSpeakingEnabled = true;

  @override
  void initState() {
    super.initState();
    _speakRecommendations(); // Speak on page load by default
  }

  Future<void> _speakRecommendations() async {
    if (!isSpeakingEnabled) return;

    String languageCode = widget.languagePreference == 'हिंदी' ? "hi-IN" : "en-IN";
    double rate = widget.languagePreference == 'हिंदी' ? 0.8 : 0.9;

    await flutterTts.setLanguage(languageCode);
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setVolume(1.0);

    String intro = widget.languagePreference == 'हिंदी'
        ? "आपके उद्देश्यों के आधार पर, हम निम्नलिखित कोर्स सुझाते हैं:"
        : "Based on your goals, here are the courses we recommend:";

    String courseList = widget.recommendedCourses
        .map((c) => _applyAgeGenderFilter(c))
        .map((c) => c.replaceAll("–", ""))
        .join(", ");

    await flutterTts.speak("$intro $courseList");
  }

  void _toggleVoice() async {
    setState(() {
      isSpeakingEnabled = !isSpeakingEnabled;
    });
    if (!isSpeakingEnabled) {
      await flutterTts.stop();
    } else {
      await _speakRecommendations();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final safeUserName = widget.userName.trim().isEmpty ? "there" : widget.userName;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FB),
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: const Text(
            "🎯 Recommended Courses",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.white,
            ),
            maxLines: 2,
            overflow: TextOverflow.visible,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              isSpeakingEnabled ? Icons.volume_up : Icons.volume_off,
              color: Colors.white,
            ),
            onPressed: _toggleVoice,
            tooltip: isSpeakingEnabled ? "Mute AI Mentor" : "Unmute AI Mentor",
          )
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.getWelcomeResponse(safeUserName, widget.languagePreference),
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Color(0xFF0D47A1),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.star, color: Colors.orangeAccent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _getLocalizedCourseIntro(localizations, widget.languagePreference),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.recommendedCourses.length,
                  itemBuilder: (context, index) {
                    final courseTitle = _applyAgeGenderFilter(widget.recommendedCourses[index]);
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: const Icon(Icons.bookmark, color: Color(0xFF1565C0)),
                        title: Text(
                          courseTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Text(
                          _whyThisCourse(courseTitle),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(_getComingSoonText(widget.languagePreference)),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(Icons.rocket_launch, color: Colors.white),
                      label: Text(
                        _getStartCourseLabel(widget.languagePreference),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1565C0),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    icon: const Icon(Icons.home_outlined, color: Color(0xFF0D47A1)),
                    label: Text(
                      _getGoHomeLabel(widget.languagePreference),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF0D47A1),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getLocalizedCourseIntro(AppLocalizations loc, String lang) {
    return lang == 'हिंदी'
        ? "आपके उद्देश्यों और अनुभव के आधार पर, हमने आपके लिए विशेष कोर्स चुने हैं।"
        : "Based on your goals and experience, we've selected personalized courses for you.";
  }

  String _getStartCourseLabel(String lang) {
    return lang == 'हिंदी' ? "कोर्स शुरू करें" : "Start Course";
  }

  String _getGoHomeLabel(String lang) {
    return lang == 'हिंदी' ? "होम पर जाएं" : "Go to Home";
  }

  String _getComingSoonText(String lang) {
    return lang == 'हिंदी' ? "🚀 कोर्स जल्द आ रहा है..." : "🚀 Course access coming soon...";
  }

  String _applyAgeGenderFilter(String course) {
    if (widget.age < 18 && _isAdultCourse(course)) {
      return "Smart Daily Conversations";
    }
    return course;
  }

  bool _isAdultCourse(String course) {
    const adultTitles = [
      "Everyday English for Homemakers",
      "Office English for Professionals",
      "Business English for Managers",
      "Travel English for Global Explorers",
      "English for Interviews & Job Success",
      "Festival & Celebration English",
      "Polite English for Social Media",
      "English for Phone & Video Calls",
      "English for Govt Job Aspirants",
      "Shaadi English",
      "Temple & Tirth Yatra English",
      "Medical English for Healthcare Workers",
      "Tutor’s English Kit",
    ];
    return adultTitles.contains(course);
  }

  String _whyThisCourse(String course) {
    if (course.contains("Beginner")) return "Great for starting your English journey from scratch.";
    if (course.contains("Intermediate")) return "Perfect to boost confidence and handle real conversations.";
    if (course.contains("Advanced")) return "Designed for fluent users aiming for professional mastery.";
    if (course.contains("Job") || course.contains("Interview")) return "Helps you prepare for interviews and professional roles.";
    if (course.contains("Travel")) return "Ideal for traveling abroad or hosting global guests.";
    if (course.contains("Shaadi")) return "Useful for matrimonial meetings and family interactions.";
    return "Tailored to your learning needs and goals.";
  }
}
