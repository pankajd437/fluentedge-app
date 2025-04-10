import 'package:flutter/material.dart';
import 'package:fluentedge_app/constants.dart';
import 'package:fluentedge_app/screens/lesson_activity_page.dart';
import 'package:fluentedge_app/widgets/animated_mentor_widget.dart'; // ✅ Mentor Widget

class LessonPage extends StatelessWidget {
  final Map<String, dynamic> course;

  const LessonPage({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String title = course["title"] ?? "Course";
    final IconData icon = course["icon"] ?? Icons.menu_book;
    final Color color = course["color"] ?? kPrimaryBlue;
    final List lessonsRaw = course["lessons"] ?? [];

    const int unlockedLessons = 3;

    final List<Map<String, dynamic>> lessons = lessonsRaw.map<Map<String, dynamic>>((lesson) {
      if (lesson is Map && lesson.containsKey('title')) {
        return {
          'title': lesson['title'].toString().trim(),
          'lessonId': lesson['lessonId'] ?? '',
        };
      } else {
        return {
          'title': lesson.toString().trim(),
          'lessonId': '',
        };
      }
    }).toList();

    return Scaffold(
      backgroundColor: kBackgroundSoftBlue,
      appBar: AppBar(
        backgroundColor: kPrimaryBlue,
        centerTitle: true,
        title: Text(
          "📘 $title",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📘 Hero Icon for Course
            Center(
              child: Hero(
                tag: title,
                child: CircleAvatar(
                  radius: 34,
                  backgroundColor: color.withOpacity(0.15),
                  child: Icon(icon, size: 32, color: color),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 🤖 Static AI Mentor
            const Center(
              child: AnimatedMentorWidget(
                size: 180,
                expressionName: 'Greeting', // 👈 Static expression
              ),
            ),
            const SizedBox(height: 24),

            // 📊 Progress bar
            LinearProgressIndicator(
              value: (unlockedLessons / lessons.length).clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: color.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
            const SizedBox(height: 16),

            const Text(
              "📖 Lessons Included",
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.bold,
                color: kPrimaryIconBlue,
              ),
            ),
            const SizedBox(height: 10),

            // 📘 Lesson List
            Expanded(
              child: ListView.separated(
                itemCount: lessons.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final lesson = lessons[index];
                  final bool isUnlocked = index < unlockedLessons;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      color: isUnlocked ? Colors.white : const Color(0xFFF0F4F8),
                      border: Border.all(
                        color: isUnlocked ? color.withOpacity(0.25) : Colors.grey.shade300,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: isUnlocked
                          ? [
                              BoxShadow(
                                color: color.withOpacity(0.08),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : [],
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: isUnlocked
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LessonActivityPage(lesson: lesson),
                                ),
                              );
                            }
                          : null,
                      child: Row(
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Icon(
                              isUnlocked ? Icons.lock_open_rounded : Icons.lock_outline_rounded,
                              key: ValueKey(isUnlocked),
                              color: isUnlocked ? kPrimaryBlue : Colors.grey.shade500,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              lesson['title'],
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w500,
                                color: isUnlocked ? Colors.black87 : Colors.grey.shade600,
                              ),
                            ),
                          ),
                          if (isUnlocked)
                            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // ▶️ CTA Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  final unlockedLesson = lessons.getRange(0, unlockedLessons).first;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LessonActivityPage(lesson: unlockedLesson),
                    ),
                  );
                },
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text("Continue"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAccentGreen,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
