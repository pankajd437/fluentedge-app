import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluentedge_app/localization/app_localizations.dart';
import 'package:fluentedge_app/data/courses_list.dart';
import 'package:fluentedge_app/screens/course_detail_page.dart';

class SmartCourseRecommendationPage extends StatelessWidget {
  final String userName;
  final String languagePreference;
  final String gender;
  final int age;
  final String userLevel; // ✅ NEW
  final List<String> recommendedCourses;

  const SmartCourseRecommendationPage({
    Key? key,
    required this.userName,
    required this.languagePreference,
    required this.gender,
    required this.age,
    required this.userLevel, // ✅ NEW
    required this.recommendedCourses,
  }) : super(key: key);

  IconData _getIconForCourse(String title) {
    final match = courses.firstWhere(
      (c) => c['title'].toLowerCase() == title.toLowerCase(),
      orElse: () => {"icon": Icons.lightbulb_outline},
    );
    return match["icon"] as IconData;
  }

  String _getStartCourseLabel(String lang) {
    return lang == 'हिंदी' ? "कोर्स शुरू करें" : "Start Course";
  }

  String _getComingSoonText(String lang) {
    return lang == 'हिंदी' ? "🚀 कोर्स जल्द आ रहा है..." : "🚀 Course access coming soon...";
  }

  String _whyThisCourse(String c) {
    if (c.contains("Beginner")) return "Great for starting your English journey from scratch.";
    if (c.contains("Intermediate")) return "Perfect to boost confidence and handle real conversations.";
    if (c.contains("Advanced")) return "Designed for fluent users aiming for professional mastery.";
    if (c.contains("Job") || c.contains("Interview")) return "Helps you prepare for interviews and professional roles.";
    if (c.contains("Travel")) return "Ideal for traveling abroad or hosting global guests.";
    return "Tailored to your learning needs and goals.";
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final safeUserName = userName.trim().isEmpty ? "there" : userName;
    final isHindi = languagePreference == 'हिंदी';

    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        title: const Text(
          "🎯 Recommended Courses",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1565C0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/welcome'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isHindi
                    ? "नमस्ते $safeUserName! आपके लिए ये कोर्स सबसे अच्छे हैं:"
                    : "Hi $safeUserName! These courses are perfect for your journey:",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF0D47A1)),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: ListView.builder(
                  itemCount: recommendedCourses.length,
                  itemBuilder: (context, index) {
                    final courseTitle = recommendedCourses[index];
                    final courseData = courses.firstWhere(
                      (c) => (c["title"] as String).toLowerCase() == courseTitle.toLowerCase(),
                      orElse: () => {
                        "title": courseTitle,
                        "icon": _getIconForCourse(courseTitle),
                        "description": _whyThisCourse(courseTitle),
                        "tag": "free",
                        "lessons": [],
                      },
                    );

                    final color = courseData["color"] ?? Colors.blue;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.shade100.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Hero(
                                  tag: courseData["title"],
                                  child: CircleAvatar(
                                    backgroundColor: color.withOpacity(0.15),
                                    child: Icon(courseData["icon"], color: color, size: 22),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        courseData["title"],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13.5,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: courseData["tag"] == "free"
                                              ? Colors.green.shade100
                                              : Colors.orange.shade100,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          courseData["tag"] == "free" ? "FREE" : "PREMIUM",
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: courseData["tag"] == "free"
                                                ? Colors.green.shade700
                                                : Colors.orange.shade700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    context.push('/courseDetail', extra: courseData);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF43A047),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  child: Text(
                                    isHindi ? "शुरू करें" : "Start Now",
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              courseData["description"],
                              style: const TextStyle(
                                fontSize: 12.5,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () {
                    context.go('/coursesDashboard');
                  },
                  child: Text(
                    isHindi ? "🔍 सभी कोर्स देखें" : "🔍 Explore All Courses",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF0D47A1),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
