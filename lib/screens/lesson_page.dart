import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluentedge_app/constants.dart';
import 'package:fluentedge_app/screens/lesson_activity_page.dart';
import 'package:fluentedge_app/widgets/animated_mentor_widget.dart';

class LessonPage extends StatelessWidget {
  final String courseTitle;
  final IconData courseIcon;
  final Color courseColor;
  final List<Map<String, dynamic>> lessons;

  const LessonPage({
    Key? key,
    required this.courseTitle,
    required this.courseIcon,
    required this.courseColor,
    required this.lessons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int unlockedLessons = lessons.length;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        final scale = 0.95 + (0.05 * value);
        return Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Scaffold(
        backgroundColor: kBackgroundSoftBlue,
        appBar: AppBar(
          backgroundColor: kPrimaryBlue,
          foregroundColor: Colors.white,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              GoRouter.of(context).go('/coursesDashboard');
            },
          ),
          title: Text(
            "📘 $courseTitle",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
              Center(
                child: AnimatedMentorWidget(
                  size: 180,
                  expressionName: 'mentor_tip_upper.png',
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

                    final List<Color> cardGradient = isUnlocked
                        ? [Colors.white, Colors.white70]
                        : [const Color(0xFFF0F4F8), const Color(0xFFE4ECF2)];

                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
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
                      child: Material(
                        elevation: 3, // ✅ Added elevation here
                        borderRadius: BorderRadius.circular(16),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: cardGradient,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(
                              color: isUnlocked
                                  ? courseColor.withOpacity(0.25)
                                  : Colors.grey.shade300,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: isUnlocked
                                ? [
                                    BoxShadow(
                                      color: courseColor.withOpacity(0.12),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Row(
                            children: [
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: Icon(
                                  isUnlocked
                                      ? Icons.lock_open_rounded
                                      : Icons.lock_outline_rounded,
                                  key: ValueKey(isUnlocked),
                                  color: isUnlocked
                                      ? kPrimaryBlue
                                      : Colors.grey.shade500,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  lessonTitle,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: isUnlocked
                                        ? Colors.black87
                                        : Colors.grey.shade600,
                                  ),
                                ),
                              ),
                              if (isUnlocked)
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
