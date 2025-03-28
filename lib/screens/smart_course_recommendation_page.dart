import 'package:flutter/material.dart';
import 'package:fluentedge_app/localization/app_localizations.dart';

class SmartCourseRecommendationPage extends StatelessWidget {
  final String userName;
  final String languagePreference;
  final String gender;
  final int age;
  final List<String> recommendedCourses;

  const SmartCourseRecommendationPage({
    super.key,
    required this.userName,
    required this.languagePreference,
    required this.gender,
    required this.age,
    required this.recommendedCourses,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final safeUserName = userName.trim().isEmpty ? "there" : userName;
    final List<String> finalCourses = recommendedCourses.isNotEmpty
        ? recommendedCourses
        : ["Smart Daily Conversations"];

    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FB),
      appBar: AppBar(
        title: const Text("🎯 Recommended Courses"),
        backgroundColor: const Color(0xFF1565C0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.getWelcomeResponse(safeUserName, languagePreference),
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Color(0xFF0D47A1),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _getLocalizedIntro(languagePreference),
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: finalCourses.length,
                itemBuilder: (context, index) {
                  final course = _applyAgeGenderFilter(finalCourses[index]);
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.school, color: Color(0xFF1565C0)),
                      title: Text(
                        course,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        _getLocalizedCourseTitle(course, languagePreference),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Navigate to course
              },
              icon: const Icon(Icons.rocket_launch),
              label: Text(_getStartLabel(languagePreference)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              icon: const Icon(Icons.home_outlined),
              label: Text(_getHomeLabel(languagePreference)),
            )
          ],
        ),
      ),
    );
  }

  String _applyAgeGenderFilter(String course) {
    if (age < 18 && _isAdultCourse(course)) {
      return "Smart Daily Conversations";
    }
    return course;
  }

  bool _isAdultCourse(String course) {
    const adultCourses = [
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
    return adultCourses.contains(course);
  }

  String _getLocalizedIntro(String lang) {
    return lang == 'हिंदी'
        ? "आपके जवाबों के आधार पर, ये कोर्स आपके लिए सबसे उपयुक्त हैं।"
        : "Based on your answers, these courses are ideal for you.";
  }

  String _getLocalizedCourseTitle(String course, String lang) {
    return lang == 'हिंदी' ? "कोर्स: $course" : "Course: $course";
  }

  String _getStartLabel(String lang) {
    return lang == 'हिंदी' ? "कोर्स शुरू करें" : "Start Course";
  }

  String _getHomeLabel(String lang) {
    return lang == 'हिंदी' ? "होम पर जाएं" : "Go to Home";
  }
}
