import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import 'package:fluentedge_app/constants.dart';
import 'package:fluentedge_app/widgets/animated_mentor_widget.dart';

class ProfilingResultPage extends StatelessWidget {
  /// Required fields
  final int score;
  final int total;
  final String userName;
  final String languagePreference;
  final String gender;
  final int age;
  final List<String> recommendedCourses;

  /// NEW: We add 'userLevel' so we can pass it to the SmartCourseRecommendationPage
  final String userLevel;

  const ProfilingResultPage({
    Key? key,
    required this.score,
    required this.total,
    required this.userName,
    required this.languagePreference,
    required this.gender,
    required this.age,
    required this.recommendedCourses,
    required this.userLevel, // <--- Added this parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 1) Compute ratio & decide message
    final double ratio = total > 0 ? score / total : 0.0;
    final bool isHigh = ratio >= 0.7;
    final String message = isHigh
        ? "Awesome job! You're ready to learn 🚀"
        : "Let’s build your skills step-by-step!";
    final String mentorExpr =
        isHigh ? 'mentor_proud_full.png' : 'mentor_reassure_upper.png';

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF90CAF9), Color(0xFFE3F2FD)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 1),

              // Score & message area (white box + optional confetti)
              Expanded(
                flex: 3,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (isHigh)
                        Lottie.asset(
                          'assets/animations/confetti_success.json',
                          width: 400,
                          height: 400,
                          repeat: false,
                        ),
                      Container(
                        padding: const EdgeInsets.all(24),
                        margin: const EdgeInsets.symmetric(horizontal: 32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "🎯 Skill Check Score: $score / $total",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              message,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Mentor image
              Expanded(
                flex: 2,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value * 1.5,
                      child: child,
                    );
                  },
                  child: AnimatedMentorWidget(
                    size: 240,
                    expressionName: mentorExpr,
                  ),
                ),
              ),

              // "Show My Course Recommendations" button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.school),
                    label: const Text("Show My Course Recommendations"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 6,
                    ),
                    onPressed: () {
                      // Pass all user data + recommendedCourses + userLevel
                      context.go(
                        routeCourseRecommendations,
                        extra: {
                          'userName': userName,
                          'languagePreference': languagePreference,
                          'gender': gender,
                          'age': age,
                          'recommendedCourses': recommendedCourses,
                          'userLevel': userLevel, // <--- We add userLevel here
                        },
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
