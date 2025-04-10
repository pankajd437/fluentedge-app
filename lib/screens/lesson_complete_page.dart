import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:fluentedge_app/constants.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:fluentedge_app/data/user_state.dart';
import 'package:hive/hive.dart';
import 'package:fluentedge_app/services/notification_service.dart';

class LessonCompletePage extends StatefulWidget {
  final String lessonTitle;
  final int earnedXP;

  const LessonCompletePage({
    Key? key,
    required this.lessonTitle,
    this.earnedXP = kLessonCompletionPoints,
  }) : super(key: key);

  @override
  State<LessonCompletePage> createState() => _LessonCompletePageState();
}

class _LessonCompletePageState extends State<LessonCompletePage> {
  bool _xpPosted = false;
  bool _isCorrect = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = GoRouterState.of(context).extra;
    if (args is Map && args.containsKey('isCorrect')) {
      _isCorrect = args['isCorrect'] == true;
    }

    if (_isCorrect && !_xpPosted) {
      _handleLessonCompletion();
    }
  }

  Future<void> _handleLessonCompletion() async {
    final name = await UserState.getUserName() ?? "Anonymous";
    final lessonId = widget.lessonTitle.replaceAll(' ', '_').toLowerCase();
    final xp = widget.earnedXP;

    final xpUrl = Uri.parse("http://10.0.2.2:8000/api/v1/user/xp?name=$name&lesson_id=$lessonId&xp=$xp");
    final streakUrl = Uri.parse("http://10.0.2.2:8000/api/v1/user/streak?name=$name&xp=$xp");

    try {
      await http.post(xpUrl);
      await http.post(streakUrl);
      await _markLessonAsCompleted(lessonId);
      await NotificationService.scheduleDailyReminder();
      setState(() => _xpPosted = true);
    } catch (e) {
      debugPrint("❌ Failed to send XP, streak, or save lesson: $e");
    }
  }

  Future<void> _markLessonAsCompleted(String lessonId) async {
    final box = await Hive.openBox('completed_lessons');
    if (!box.containsKey(lessonId)) {
      await box.put(lessonId, true);
      debugPrint("✅ Lesson marked completed: $lessonId");
    }

    debugPrint("📘 Total Completed Lessons: ${box.keys.length}");
    debugPrint("📘 Completed IDs: ${box.keys.toList()}");
  }

  @override
  Widget build(BuildContext context) {
    final headlineText = _isCorrect ? "Well done!" : "Keep trying!";
    final subText = _isCorrect
        ? "You’ve completed the lesson:\n‘${widget.lessonTitle}’"
        : "You attempted the lesson:\n‘${widget.lessonTitle}’";

    return Scaffold(
      backgroundColor: kBackgroundSoftBlue,
      appBar: AppBar(
        backgroundColor: kPrimaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "🎉 Lesson Complete",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/confetti_success.json',
              height: 200,
              repeat: false,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            Lottie.asset(
              'assets/animations/badge_unlocked.json',
              height: 120,
              repeat: false,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
            Text(
              headlineText,
              style: TextStyle(
                fontSize: 22,
                fontWeight: kWeightBold,
                color: kPrimaryIconBlue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            // XP container only shown on correct answer
            if (_isCorrect)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: kAccentGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "🎓 +${widget.earnedXP} XP Earned!",
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: kAccentGreen,
                  ),
                ),
              ),

            const Spacer(),

            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => GoRouter.of(context).go('/coursesDashboard'),
                    icon: const Icon(Icons.arrow_forward_ios),
                    label: const Text("Back to Dashboard"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kAccentGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: () => GoRouter.of(context).push('/achievements'),
                  icon: const Icon(Icons.emoji_events_outlined, color: kPrimaryBlue),
                  label: const Text(
                    "View Achievements",
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: kPrimaryBlue,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
