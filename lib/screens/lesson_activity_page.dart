import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:fluentedge_app/constants.dart';

class LessonActivityPage extends StatelessWidget {
  final Map<String, dynamic> lesson;

  const LessonActivityPage({
    Key? key,
    required this.lesson,
  }) : super(key: key);

  void _showResultAnimation(BuildContext context, bool isCorrect) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Center(
        child: SizedBox(
          width: 220,
          height: 220,
          child: Lottie.asset(
            isCorrect
                ? 'assets/animations/activity_correct.json'
                : 'assets/animations/activity_wrong.json',
            repeat: false,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    final String lessonTitle = lesson['title'] ?? 'Lesson Title';
    final String lessonId = lesson['lessonId'] ?? 'lesson_id';

    final String activityQuestion = "Which word means the opposite of 'cold'?";
    final List<String> options = ['Hot', 'Warm', 'Freeze', 'Cool'];
    final int correctIndex = 0;

    final List<List<Color>> optionGradients = [
      [Colors.deepPurple, Colors.purpleAccent],
      [Colors.blue, Colors.lightBlue],
      [Colors.green, Colors.lightGreen],
      [Colors.orange, Colors.deepOrange],
      [Colors.teal, Colors.cyan],
    ];

    return Scaffold(
      backgroundColor: kBackgroundSoftBlue,
      appBar: AppBar(
        backgroundColor: kPrimaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          lessonTitle,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "🧠 Activity",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: kPrimaryIconBlue,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              activityQuestion,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),

            ...options.asMap().entries.map((entry) {
              final index = entry.key;
              final value = entry.value;
              final gradient = optionGradients[index % optionGradients.length];

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradient),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      final isCorrect = index == correctIndex;
                      _showResultAnimation(context, isCorrect);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Row(
                        children: [
                          const Icon(Icons.circle_outlined, color: Colors.white, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              value,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  GoRouter.of(context).push(
                    '/lessonComplete',
                    extra: {'lessonTitle': lessonTitle},
                  );
                },
                icon: const Icon(Icons.check_circle_outline),
                label: const Text("Complete Lesson"),
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
