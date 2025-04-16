// -----------------------------------------
// lesson_complete_page.dart
// -----------------------------------------

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:fluentedge_app/constants.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:fluentedge_app/data/user_state.dart';
import 'package:hive/hive.dart';
import 'package:fluentedge_app/services/notification_service.dart';

class LessonCompletePage extends StatefulWidget {
  final String lessonId;
  final String lessonTitle;
  final int earnedXP;
  final String? badgeId;

  const LessonCompletePage({
    Key? key,
    required this.lessonId,
    required this.lessonTitle,
    this.earnedXP = kLessonCompletionPoints,
    this.badgeId,
  }) : super(key: key);

  @override
  State<LessonCompletePage> createState() => _LessonCompletePageState();
}

class _LessonCompletePageState extends State<LessonCompletePage> {
  bool _xpPosted = false;
  bool _isCorrect = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = GoRouterState.of(context).extra;
    if (args is Map && args.containsKey('isCorrect')) {
      _isCorrect = args['isCorrect'] == true;
    }

    // Only mark as completed & post XP if user passed and we haven't already posted
    if (_isCorrect && !_xpPosted) {
      _handleLessonCompletion();
    }
  }

  /// Posts XP, updates streak, marks lesson completed, schedules reminder
  Future<void> _handleLessonCompletion() async {
    final name = await UserState.getUserName() ?? "Anonymous";
    final xp = widget.earnedXP;

    final xpUrl = Uri.parse("http://10.0.2.2:8000/api/v1/user/xp?name=$name&lesson_id=${widget.lessonId}&xp=$xp");
    final streakUrl = Uri.parse("http://10.0.2.2:8000/api/v1/user/streak?name=$name&xp=$xp");

    try {
      // Post XP & streak increment
      await http.post(xpUrl);
      await http.post(streakUrl);

      // Mark lesson completed locally
      await _markLessonAsCompleted(widget.lessonId);

      // Schedule daily reminder
      await NotificationService.scheduleDailyReminder();

      setState(() => _xpPosted = true);
    } catch (e) {
      debugPrint("❌ Failed to update progress: $e");
    }
  }

  /// Stores lessonId in 'completed_lessons' box if not present
  Future<void> _markLessonAsCompleted(String lessonId) async {
    final box = await Hive.openBox('completed_lessons');
    if (!box.containsKey(lessonId)) {
      await box.put(lessonId, true);
      debugPrint("✅ Lesson marked completed: $lessonId");
    }
    debugPrint("📘 Completed Lessons: ${box.keys.length} → ${box.keys.toList()}");
  }

  @override
  Widget build(BuildContext context) {
    final bool isPassed = _isCorrect;
    // Headline & subtext differ based on pass/fail
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
          "Lesson Complete",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        elevation: 0,
      ),
      // Bottom bar with centered Home icon → /coursesDashboard
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
      body: Stack(
        children: [
          // Subtle background animation
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: Lottie.asset(
                isPassed ? 'assets/animations/confetti_success.json' : 'assets/animations/activity_wrong.json',
                repeat: true,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Main success/fail animation
                  Lottie.asset(
                    isPassed ? 'assets/animations/success_checkmark.json' : 'assets/animations/activity_wrong.json',
                    height: 160,
                    repeat: false,
                  ),
                  const SizedBox(height: 14),

                  // Show the badge if user passed & there's a badgeId
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
                  // Headline & subText
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

                  // Show XP earned if user passed
                  if (isPassed)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
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

                  // Bottom Buttons
                  Column(
                    children: [
                      // Return to Dashboard
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => GoRouter.of(context).go('/coursesDashboard'),
                          icon: const Icon(Icons.dashboard),
                          label: const Text("Back to Dashboard"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kAccentGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // If passed, show Next Lesson or Another Lesson
                      if (isPassed)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => GoRouter.of(context).go('/lessonPage'),
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

                      // If passed, show Achievements; if not, show Try Again
                      if (isPassed)
                        TextButton.icon(
                          onPressed: () => GoRouter.of(context).push('/achievements'),
                          icon: const Icon(Icons.emoji_events_outlined, color: kPrimaryBlue),
                          label: const Text(
                            "View Achievements",
                            style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: kPrimaryBlue),
                          ),
                        )
                      else
                        TextButton.icon(
                          onPressed: () {
                            // e.g. navigate them back to the same lesson
                            GoRouter.of(context).go('/lessonPage');
                          },
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
