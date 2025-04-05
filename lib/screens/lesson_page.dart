import 'package:flutter/material.dart';
import 'package:fluentedge_app/constants.dart';

class LessonPage extends StatelessWidget {
  final Map<String, dynamic> course;

  const LessonPage({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String title = course["title"] ?? "Course";
    final IconData icon = course["icon"] ?? Icons.menu_book;
    final Color color = course["color"] ?? kPrimaryBlue;
    final List<String> lessons = List<String>.from(course["lessons"] ?? []);

    // 🔐 Fake lesson lock logic (e.g., only first 3 are unlocked)
    const int unlockedLessons = 3;

    return Scaffold(
      backgroundColor: kBackgroundSoftBlue,
      appBar: AppBar(
        backgroundColor: kPrimaryBlue,
        centerTitle: true,
        title: Text(
          "📘 $title",
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
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
            const SizedBox(height: 24),
            LinearProgressIndicator(
              value: (unlockedLessons / lessons.length).clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: color.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
            const SizedBox(height: 14),
            const Text(
              "📖 Lessons Included",
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.bold,
                color: kPrimaryIconBlue,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: lessons.length,
                itemBuilder: (context, index) {
                  final String lesson = lessons[index];
                  final bool isUnlocked = index < unlockedLessons;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOut,
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: color.withOpacity(0.2)),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.07),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: isUnlocked
                              ? Icon(Icons.lock_open, color: color, size: 20, key: ValueKey("open$index"))
                              : Icon(Icons.lock_outline, color: Colors.grey.shade400, size: 20, key: ValueKey("lock$index")),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            lesson,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: isUnlocked ? Colors.black87 : Colors.grey.shade500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("🚀 Starting your first lesson...")),
                  );
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text("Continue"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAccentGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
