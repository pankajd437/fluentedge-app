import 'dart:convert'; // for jsonEncode
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

import 'package:fluentedge_app/constants.dart';
import 'package:fluentedge_app/data/user_state.dart';
import 'package:fluentedge_app/services/notification_service.dart';

// NEW import for Riverpod
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluentedge_app/data/user_state.dart';

class LessonCompletePage extends ConsumerStatefulWidget {
  final String lessonId;
  final String lessonTitle;
  final int earnedXP;
  final String? badgeId;
  final bool isCorrect;

  // (Optional new fields from updated structure)
  final String? badgeAnimation; // e.g. "assets/animations/badge_unlocked.json"
  final String? badgeTitle;     // e.g. "Intro Master" from "badgeAwarded" in JSON

  const LessonCompletePage({
    Key? key,
    required this.lessonId,
    required this.lessonTitle,
    this.earnedXP = kLessonCompletionPoints,
    this.badgeId,
    required this.isCorrect,

    // Optional new parameters with default = null
    this.badgeAnimation,
    this.badgeTitle,
  }) : super(key: key);

  @override
  ConsumerState<LessonCompletePage> createState() => _LessonCompletePageState();
}

class _LessonCompletePageState extends ConsumerState<LessonCompletePage> {
  bool _xpPosted = false;
  bool _alreadyCompleted = false; // to track if lesson is already done

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // If user passed the quiz, we handle awarding XP only once
    if (widget.isCorrect && !_xpPosted) {
      _handleLessonCompletion();
    }
  }

  /// 1) Check if this lesson is already completed in local Hive.
  /// 2) If new, award XP + optionally POST to backend.
  /// 3) Mark lesson as completed + schedule daily reminder.
  Future<void> _handleLessonCompletion() async {
    debugPrint("📦 Submitting lessonId: ${widget.lessonId}");

    final box = await Hive.openBox(kHiveBoxCompletedLessons);
    _alreadyCompleted = box.containsKey(widget.lessonId);

    // If previously completed, we do NOT show XP again
    if (_alreadyCompleted) {
      debugPrint("⚠️ Lesson already completed: skipping XP awarding.");
      // Still schedule daily reminder to keep user engaged
      await NotificationService.scheduleDailyReminder();
      setState(() => _xpPosted = true);
      return;
    }

    final xp = widget.earnedXP;
    final userName = await UserState.getUserName() ?? "Anonymous";

    // (A) Increment local Riverpod XP & sync to backend
    ref.read(xpProvider.notifier).incrementXP(xp);
    await ref.read(xpProvider.notifier).syncXPWithBackend();

    // (B) Attempt to retrieve user_id if user is actually registered
    final userId = await UserState.getUserId() ?? '';
    if (userId.isEmpty) {
      // If guest => just mark done locally
      debugPrint("⚠️ Guest user—skipping XP POST to the backend.");
      await _markLessonAsCompleted(widget.lessonId);
      await NotificationService.scheduleDailyReminder();
      setState(() => _xpPosted = true);
      return;
    }

    // (C) Build POST request for /api/v1/user/progress
    final endpointUrl = Uri.parse("${ApiConfig.local}/api/v1/user/progress");
    final body = {
      "user_id": userId,
      "user_name": userName,
      "lesson_id": widget.lessonId,
      "xp_earned": xp,
    };

    try {
      final response = await http.post(
        endpointUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        debugPrint("✅ Lesson XP saved: $xp for $userName, lesson=${widget.lessonId}");
      } else {
        debugPrint("❌ XP post failed: ${response.statusCode} => ${response.body}");
      }

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
    debugPrint("📘 Completed Lessons: ${box.keys.length} => ${box.keys.toList()}");
  }

  @override
  Widget build(BuildContext context) {
    final isPassed = widget.isCorrect;

    final String headline = isPassed ? "🎉 Great Job!" : "😅 Not Quite!";
    final String subText = isPassed
        ? "You’ve completed:\n‘${widget.lessonTitle}’"
        : "You attempted:\n‘${widget.lessonTitle}’\nBut don’t worry — let’s try again soon!";

    // If user unlocked a badge, show it
    final bool hasBadge = (isPassed && widget.badgeId != null);

    // Use custom or fallback badge animation
    final String badgeAnimationPath =
        (widget.badgeAnimation?.trim().isNotEmpty == true)
            ? widget.badgeAnimation!
            : 'assets/animations/badge_unlocked.json';

    // If JSON had a special badge title, show it
    final String? badgeTitle =
        (widget.badgeTitle?.trim().isNotEmpty == true) ? widget.badgeTitle : null;

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
      body: Stack(
        children: [
          // Subtle confetti background if success
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
                  // Big animation
                  Lottie.asset(
                    isPassed
                        ? 'assets/animations/success_checkmark.json'
                        : 'assets/animations/activity_wrong.json',
                    height: 160,
                    repeat: false,
                  ),
                  const SizedBox(height: 14),

                  // Badge if relevant
                  if (hasBadge) ...[
                    Text(
                      badgeTitle != null
                          ? "🏅 You’ve unlocked the badge: $badgeTitle!"
                          : "🏅 You’ve unlocked a badge!",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: kAccentGreen,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Lottie.asset(
                      badgeAnimationPath,
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
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Only show XP bar if first time awarding XP
                  if (isPassed && !_alreadyCompleted)
                    AnimatedContainer(
                      duration: kShortAnimationDuration,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: kAccentGreen.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: kAccentGreen.withOpacity(0.4),
                        ),
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

                  // Footer Buttons
                  Column(
                    children: [
                      // Dashboard
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => context.go(routeCoursesDashboard),
                          icon: const Icon(Icons.dashboard),
                          label: const Text("Back to Dashboard"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kAccentGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // User Dashboard
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => context.go('/userDashboard'),
                          icon: const Icon(Icons.person),
                          label: const Text("User Dashboard"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Next Lesson or Another
                      if (isPassed)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => context.go(routeLessonPage),
                            icon: const Icon(Icons.menu_book_outlined),
                            label: const Text("Next Lesson / Choose Another"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 10),

                      // Achievements or Try Again
                      if (isPassed)
                        TextButton.icon(
                          onPressed: () => context.push(routeAchievements),
                          icon: const Icon(
                            Icons.emoji_events_outlined,
                            color: kPrimaryBlue,
                          ),
                          label: const Text(
                            "View Achievements",
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: kPrimaryBlue,
                            ),
                          ),
                        )
                      else
                        TextButton.icon(
                          onPressed: () => context.go(routeLessonPage),
                          icon: const Icon(Icons.refresh, color: Colors.orange),
                          label: const Text(
                            "Try Again",
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange,
                            ),
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
