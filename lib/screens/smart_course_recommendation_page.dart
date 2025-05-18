import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluentedge_app/localization/app_localizations.dart';
import 'package:fluentedge_app/data/beginner_courses_list.dart';
import 'package:fluentedge_app/data/intermediate_courses_list.dart';
import 'package:fluentedge_app/data/advanced_courses_list.dart';

// For routeCourseDetail, routeCoursesDashboard references
import 'package:fluentedge_app/constants.dart';
// Import the animated mentor widget
import 'package:fluentedge_app/widgets/animated_mentor_widget.dart';

import 'package:lottie/lottie.dart'; // For confetti or cheer animation

class SmartCourseRecommendationPage extends StatelessWidget {
  final String userName;
  final String languagePreference;
  final String gender;
  final int age;
  final List<String> recommendedCourses;
  final String userLevel;

  const SmartCourseRecommendationPage({
    Key? key,
    required this.userName,
    required this.languagePreference,
    required this.gender,
    required this.age,
    required this.recommendedCourses,
    required this.userLevel,
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

    // Debug prints
    debugPrint("DEBUG => userLevel: $userLevel");
    debugPrint("DEBUG => recommendedCourses: $recommendedCourses");
    debugPrint("DEBUG => matchedCourses titles: ${matchedCourses.map((c) => c['title']).toList()}");

    return Scaffold(
      // Subtle gradient background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)], // Soft Blue Gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top AppBar
              AppBar(
                backgroundColor: const Color(0xFF1565C0),
                elevation: 0,
                centerTitle: true,
                title: const Text(
                  "🎯 Recommended Courses",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),

              // Mentor expression header
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 12),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueGrey.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    AnimatedMentorWidget(
                      size: 110,
                      expressionName: 'mentor_celebrate_full.png',
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localizations.getWelcomeResponse(safeUserName, languagePreference),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Color(0xFF0D47A1),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _getLocalizedIntro(languagePreference),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Main content
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF2F6FB),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // If no matched courses
                      if (matchedCourses.isEmpty)
                        const Center(
                          child: Text(
                            "No matching courses found.\nPlease complete the questionnaire again for fresh suggestions.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14, color: Colors.black54),
                          ),
                        )
                      else
                        // List of matched courses
                        Expanded(
                          child: ListView.builder(
                            itemCount: matchedCourses.length,
                            itemBuilder: (context, index) {
                              final course = matchedCourses[index];
                              return TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0.95, end: 1.0),
                                duration: Duration(milliseconds: 300 + index * 100),
                                builder: (context, scale, child) {
                                  return Transform.scale(
                                    scale: scale,
                                    child: child,
                                  );
                                },
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Row for icon + FREE/PREMIUM
                                        Row(
                                          children: [
                                            Hero(
                                              tag: course['title'],
                                              child: CircleAvatar(
                                                backgroundColor: course['color'].withOpacity(0.1),
                                                child: Icon(course['icon'], color: course['color']),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: course['tag'] == kFreeCourseTag
                                                    ? Colors.green
                                                    : Colors.orange,
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                course['tag'],
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        // Course Title
                                        Text(
                                          course["title"],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        // Course Description
                                        Text(
                                          course["description"],
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                        const SizedBox(height: 10),
                                        // Start Now button (with 2s Lottie)
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              elevation: 2,
                                              backgroundColor: Colors.green, // fixed green
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 8,
                                              ),
                                              textStyle: const TextStyle(fontSize: 13),
                                            ),
                                            onPressed: () async {
                                              // Show confetti for up to 2s
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (_) => Center(
                                                  child: Lottie.asset(
                                                    'assets/animations/quiz_celebration.json',
                                                    repeat: false,
                                                  ),
                                                ),
                                              );

                                              // Delay 1s then close dialog
                                              await Future.delayed(const Duration(seconds: 1));
                                              if (Navigator.canPop(context)) {
                                                Navigator.pop(context);
                                              }

                                              // Then navigate to course detail
                                              context.go(routeCourseDetail, extra: course);
                                            },
                                            child: const Text("Start Now"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                      const SizedBox(height: 10),

                      // "Explore All Courses" button
                      ElevatedButton.icon(
                        onPressed: () {
                          context.go(routeCoursesDashboard);
                        },
                        icon: const Icon(Icons.dashboard_customize),
                        label: const Text('Explore All Courses'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF1565C0),
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Color(0xFF1565C0)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getLocalizedIntro(String lang) {
    return lang == 'हिंदी'
        ? "आपके जवाबों के आधार पर, ये कोर्स आपके लिए सबसे उपयुक्त हैं।"
        : "Based on your answers, these courses are ideal for you.";
  }
}
