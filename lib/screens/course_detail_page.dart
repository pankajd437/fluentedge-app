import 'package:flutter/material.dart';
import 'package:fluentedge_app/constants.dart';
import 'package:fluentedge_app/screens/lesson_page.dart';

class CourseDetailPage extends StatelessWidget {
  final Map<String, dynamic> course;

  const CourseDetailPage({
    Key? key,
    required this.course,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Color> iconColors = [
      Colors.orange,
      Colors.teal,
      Colors.purple,
      Colors.pinkAccent,
      Colors.green,
      Colors.indigo,
      Colors.deepOrange,
      Colors.cyan,
    ];

    final String title = course["title"] ?? "Course Title";
    final IconData icon = course["icon"] ?? Icons.info_outline;
    final Color color = course["color"] ?? Colors.blue;
    final String description = course["description"] ?? "No description available.";
    final String tag = course["tag"] ?? kFreeCourseTag;

    final List lessonsRaw = course["lessons"] ?? [];
    final List<String> lessonTitles = lessonsRaw.map<String>((lesson) {
      if (lesson is Map && lesson.containsKey('title')) {
        return lesson['title'].toString();
      } else if (lesson is String) {
        return lesson.trim();
      } else {
        return lesson.toString();
      }
    }).toList();

    return Scaffold(
      backgroundColor: kBackgroundSoftBlue,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [kPrimaryBlue, kSecondaryBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Hero(
                  tag: title,
                  child: CircleAvatar(
                    radius: 32,
                    backgroundColor: color.withOpacity(0.15),
                    child: Icon(icon, size: 32, color: color),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryIconBlue,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.blue.shade100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade50,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13.5,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              lessonTitles.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Text(
                          "No lessons available at this moment.",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Lessons Outline",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryIconBlue,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...lessonTitles.asMap().entries.map((entry) {
                          final int index = entry.key;
                          final String lesson = entry.value;
                          final Color iconColor = iconColors[index % iconColors.length];
                          final bool isHindi = RegExp(r'[\u0900-\u097F]').hasMatch(lesson);

                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE3F2FD)),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.play_circle_fill_rounded, color: iconColor, size: 24),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    isHindi ? "📘 $lesson" : lesson,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.rocket_launch_rounded, size: 18),
                  onPressed: () {
                    if (lessonTitles.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LessonPage(course: course),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kAccentGreen,
                    foregroundColor: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  label: Text(
                    tag == kPaidCourseTag ? "Unlock Premium" : "Start Lesson",
                    style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
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
