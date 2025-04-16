import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // For the Home icon navigation
import 'package:fluentedge_app/constants.dart';
import 'package:fluentedge_app/screens/lesson_activity_page.dart';
import 'package:fluentedge_app/widgets/animated_mentor_widget.dart';

class LessonPage extends StatelessWidget {
  final String courseTitle;
  final IconData courseIcon;
  final Color courseColor;
  final List<Map<String, String>> lessons;

  const LessonPage({
    Key? key,
    required this.courseTitle,
    required this.courseIcon,
    required this.courseColor,
    required this.lessons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int unlockedLessons = lessons.length; // All lessons are unlocked

    return Scaffold(
      backgroundColor: kBackgroundSoftBlue,
      appBar: AppBar(
        backgroundColor: kPrimaryBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "📘 $courseTitle",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      // Bottom bar with Home icon → /coursesDashboard
      bottomNavigationBar: BottomAppBar(
        color: kPrimaryBlue,
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
            Center(
              child: Hero(
                tag: courseTitle,
                child: CircleAvatar(
                  radius: 34,
                  backgroundColor: courseColor.withOpacity(0.15),
                  child: Icon(courseIcon, size: 32, color: courseColor),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ✅ Animated Mentor
            const Center(
              child: AnimatedMentorWidget(
                size: 180,
                expressionName: 'Greeting',
              ),
            ),
            const SizedBox(height: 24),

            LinearProgressIndicator(
              value: (unlockedLessons / lessons.length).clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: courseColor.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(courseColor),
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

            Expanded(
              child: ListView.separated(
                itemCount: lessons.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final lesson = lessons[index];
                  final String lessonTitle = lesson["title"] ?? "Untitled";
                  final String lessonId = lesson["lessonId"] ?? "";
                  final String lessonJsonPath = 'assets/lessons/$lessonId.json';
                  final bool isUnlocked = index < unlockedLessons;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      color: isUnlocked ? Colors.white : const Color(0xFFF0F4F8),
                      border: Border.all(
                        color: isUnlocked ? courseColor.withOpacity(0.25) : Colors.grey.shade300,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: isUnlocked
                          ? [
                              BoxShadow(
                                color: courseColor.withOpacity(0.08),
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
                                  builder: (context) => LessonActivityPage(
                                    lessonTitle: lessonTitle,
                                    lessonJsonPath: lessonJsonPath,
                                  ),
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
                              lessonTitle,
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

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  final unlockedLesson = lessons.first;
                  final lessonJsonPath = 'assets/lessons/${unlockedLesson["lessonId"]}.json';
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LessonActivityPage(
                        lessonTitle: unlockedLesson["title"] ?? "Untitled",
                        lessonJsonPath: lessonJsonPath,
                      ),
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
