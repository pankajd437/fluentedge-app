import 'package:flutter/material.dart';
import 'package:fluentedge_app/localization/app_localizations.dart';
import 'package:fluentedge_app/data/beginner_courses_list.dart';
import 'package:fluentedge_app/data/intermediate_courses_list.dart';
import 'package:fluentedge_app/data/advanced_courses_list.dart';
import 'package:go_router/go_router.dart';

class SmartCourseRecommendationPage extends StatelessWidget {
  final String userName;
  final String languagePreference;
  final String gender;
  final int age;
  final List<String> recommendedCourses;

  /// For demonstration, userLevel is hard-coded.
  /// In a real app, you might pass or compute this.
  final String userLevel = "beginner"; // 'intermediate' or 'advanced'

  const SmartCourseRecommendationPage({
    Key? key,
    required this.userName,
    required this.languagePreference,
    required this.gender,
    required this.age,
    required this.recommendedCourses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final safeUserName = userName.trim().isEmpty ? "there" : userName;

    // Select course list based on userLevel
    final List<Map<String, dynamic>> allCourses = userLevel == "intermediate"
        ? intermediateCourses
        : userLevel == "advanced"
            ? advancedCourses
            : beginnerCourses;

    final List<Map<String, dynamic>> matchedCourses = allCourses.where((course) {
      return recommendedCourses.contains(course["title"]);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FB),
      appBar: AppBar(
        title: const Text(
          "🎯 Recommended Courses",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1565C0),
      ),
      // Bottom bar with centered Home icon → /coursesDashboard
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF1565C0),
        child: SizedBox(
          height: 50, // smaller bar height
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 36, // bigger home icon
                icon: const Icon(Icons.home),
                color: Colors.white,
                onPressed: () {
                  // Navigate to courses dashboard
                  GoRouter.of(context).go('/coursesDashboard');
                },
              ),
            ],
          ),
        ),
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

            if (matchedCourses.isEmpty)
              const Center(
                child: Text(
                  "No matching courses found.\nPlease complete the questionnaire again for fresh suggestions.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: matchedCourses.length,
                  itemBuilder: (context, index) {
                    final course = matchedCourses[index];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, '/courseDetail', arguments: course);
                        },
                        leading: CircleAvatar(
                          backgroundColor: course['color'].withOpacity(0.1),
                          child: Icon(course['icon'], color: course['color']),
                        ),
                        title: Text(
                          course["title"],
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          course["description"],
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
                if (matchedCourses.isNotEmpty) {
                  Navigator.pushNamed(
                    context,
                    '/courseDetail',
                    arguments: matchedCourses.first,
                  );
                }
              },
              icon: const Icon(Icons.rocket_launch),
              label: Text(_getStartLabel(languagePreference)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
              ),
            ),

            // Removed original "Go to Home" text button to avoid duplication with bottom bar.
          ],
        ),
      ),
    );
  }

  String _getLocalizedIntro(String lang) {
    return lang == 'हिंदी'
        ? "आपके जवाबों के आधार पर, ये कोर्स आपके लिए सबसे उपयुक्त हैं।"
        : "Based on your answers, these courses are ideal for you.";
  }

  String _getStartLabel(String lang) {
    return lang == 'हिंदी' ? "कोर्स शुरू करें" : "Start Course";
  }
}
