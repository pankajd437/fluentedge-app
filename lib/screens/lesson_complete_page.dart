import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

import 'package:fluentedge_app/constants.dart';
import 'package:fluentedge_app/data/user_state.dart';
import 'package:fluentedge_app/services/notification_service.dart';

class LessonCompletePage extends StatefulWidget {
  final String lessonId;
  final String lessonTitle;
  final int earnedXP;
  final String? badgeId;
  final bool isCorrect;

  const LessonCompletePage({
    Key? key,
    required this.lessonId,
    required this.lessonTitle,
    this.earnedXP = kLessonCompletionPoints,
    this.badgeId,
    required this.isCorrect,
  }) : super(key: key);

  @override
  State<LessonCompletePage> createState() => _LessonCompletePageState();
}

class _LessonCompletePageState extends State<LessonCompletePage> {
  bool _xpPosted = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.isCorrect && !_xpPosted) {
      _handleLessonCompletion();
    }
  }

  Future<void> _handleLessonCompletion() async {
    final name = await UserState.getUserName() ?? "Anonymous";
    final xp = widget.earnedXP;

    final xpUrl = Uri.parse("${ApiConfig.local}/user/xp?name=$name&lesson_id=${widget.lessonId}&xp=$xp");
    final streakUrl = Uri.parse("${ApiConfig.local}/user/streak?name=$name&xp=$xp");

    try {
      await http.post(xpUrl);
      await http.post(streakUrl);
      await _markLessonAsCompleted(widget.lessonId);
      await NotificationService.scheduleDailyReminder();

      setState(() => _xpPosted = true);
    } catch (e) {
      debugPrint("❌ Failed to update progress: $e");
    }
  }

  Future<void> _markLessonAsCompleted(String lessonId) async {
    final box = await Hive.openBox(kHiveBoxCompletedLessons);
    if (!box.containsKey(lessonId)) {
      await box.put(lessonId, true);
      debugPrint("✅ Lesson marked completed: $lessonId");
    }
    debugPrint("📘 Completed Lessons: ${box.keys.length} → ${box.keys.toList()}");
  }

  @override
  Widget build(BuildContext context) {
    final isPassed = widget.isCorrect;

    final String headline = isPassed ? "🎉 Great Job!" : "😅 Not Quite!";
    final String subText = isPassed
        ? "You’ve completed:\n‘${widget.lessonTitle}’"
        : "You attempted:\n‘${widget.lessonTitle}’\nBut don’t worry — let’s try again soon!";

    return Scaffold(
      backgroundColor: kBackgroundSoftBlue,
      appBar: AppBar(
        backgroundColor: kPrimaryBlue,
        foregroundColor: Colors.white,
        title: const Text(
          "Lesson Complete", // TODO: localize
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        elevation: 0,
      ),
      bottomNavigationBar: BottomAppBar(
        color: kPrimaryBlue,
        child: SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 36,
                icon: const Icon(Icons.home),
                color: Colors.white,
                onPressed: () => context.go(routeCoursesDashboard),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: Lottie.asset(
                isPassed
                    ? 'assets/animations/confetti_success.json'
                    : 'assets/animations/activity_wrong.json',
                repeat: true,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(kPagePadding),
              child: Column(
                children: [
                  Lottie.asset(
                    isPassed
                        ? 'assets/animations/success_checkmark.json'
                        : 'assets/animations/activity_wrong.json',
                    height: 160,
                    repeat: false,
                  ),
                  const SizedBox(height: 14),

                  if (isPassed && widget.badgeId != null) ...[
                    const Text(
                      "🏅 You’ve unlocked a badge!",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kAccentGreen),
                    ),
                    const SizedBox(height: 10),
                    Lottie.asset(
                      'assets/animations/badge_unlocked.json',
                      height: 100,
                      repeat: false,
                    ),
                  ],

                  const SizedBox(height: 20),
                  Text(
                    headline,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: kWeightBold,
                      color: isPassed ? kPrimaryIconBlue : Colors.orange,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    subText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500, color: Colors.black87),
                  ),
                  const SizedBox(height: 16),

                  if (isPassed)
                    AnimatedContainer(
                      duration: kShortAnimationDuration,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: kAccentGreen.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: kAccentGreen.withOpacity(0.4)),
                      ),
                      child: Text(
                        "🎓 +${widget.earnedXP} XP Earned!",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: kAccentGreen,
                        ),
                      ),
                    ),

                  const Spacer(),

                  // Action Buttons
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => context.go(routeCoursesDashboard),
                          icon: const Icon(Icons.dashboard),
                          label: const Text("Back to Dashboard"), // TODO: localize
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kAccentGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      if (isPassed)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => context.go(routeLessonPage),
                            icon: const Icon(Icons.menu_book_outlined),
                            label: const Text("Next Lesson / Choose Another"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryBlue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                          ),
                        ),
                      const SizedBox(height: 10),

                      if (isPassed)
                        TextButton.icon(
                          onPressed: () => context.push(routeAchievements),
                          icon: const Icon(Icons.emoji_events_outlined, color: kPrimaryBlue),
                          label: const Text(
                            "View Achievements",
                            style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: kPrimaryBlue),
                          ),
                        )
                      else
                        TextButton.icon(
                          onPressed: () => context.go(routeLessonPage),
                          icon: const Icon(Icons.refresh, color: Colors.orange),
                          label: const Text(
                            "Try Again",
                            style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: Colors.orange),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
