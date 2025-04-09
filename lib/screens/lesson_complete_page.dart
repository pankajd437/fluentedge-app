import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:fluentedge_app/constants.dart';
import 'package:go_router/go_router.dart';

class LessonCompletePage extends StatelessWidget {
  final String lessonTitle;
  final int earnedXP;

  const LessonCompletePage({
    Key? key,
    required this.lessonTitle,
    this.earnedXP = kLessonCompletionPoints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            // 🎊 Celebration Animation
            Lottie.asset(
              'assets/animations/confetti_success.json',
              height: 200,
              repeat: false,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),

            // 🏅 Badge Animation
            Lottie.asset(
              'assets/animations/badge_unlocked.json',
              height: 120,
              repeat: false,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),

            // 🎯 Title Message
            Text(
              "Well done!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: kWeightBold,
                color: kPrimaryIconBlue,
              ),
            ),
            const SizedBox(height: 8),

            // 📘 Lesson Info
            Text(
              "You’ve completed the lesson:\n‘$lessonTitle’",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            // 🎮 XP Display
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: kAccentGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "🎓 +$earnedXP XP Earned!",
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: kAccentGreen,
                ),
              ),
            ),

            const Spacer(),

            // 🔄 CTA Buttons
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
