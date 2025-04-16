import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluentedge_app/constants.dart';
import 'package:lottie/lottie.dart';

class BadgeDetailPage extends StatelessWidget {
  final String title;
  final String imagePath;
  final bool unlocked;
  final String tag;

  const BadgeDetailPage({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.unlocked,
    required this.tag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundSoftBlue,
      appBar: AppBar(
        backgroundColor: kPrimaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text("🏅 Badge Details"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🏅 Badge animation
            Hero(
              tag: tag,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: unlocked ? Colors.white : Colors.grey.shade200,
                  boxShadow: unlocked
                      ? [
                          BoxShadow(
                            color: kAccentGreen.withOpacity(0.15),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: Lottie.asset(
                  imagePath,
                  height: 130,
                  repeat: unlocked,
                  animate: unlocked,
                  fit: BoxFit.contain,
                  frameRate: FrameRate.max,
                  delegates: LottieDelegates(
                    values: [
                      ValueDelegate.color(
                        const ['**'],
                        value: unlocked ? null : Colors.grey.shade400,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 🎖 Badge title
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: kWeightBold,
                color: kPrimaryIconBlue,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),

            // 🔓 Unlock status
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: unlocked ? kAccentGreen.withOpacity(0.15) : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                unlocked ? "✅ Badge Unlocked!" : "🔒 Badge Locked",
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: unlocked ? kAccentGreen : Colors.grey.shade600,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ℹ️ How to earn badge
            const Text(
              "How to earn this badge:",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: kPrimaryIconBlue,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "📌 Complete relevant milestones like finishing lessons, maintaining streaks, or scoring high in quizzes to earn this badge.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),

            const Spacer(),

            // ✅ CTA
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => GoRouter.of(context).go('/achievements'),
                icon: const Icon(Icons.emoji_events),
                label: const Text("Back to Achievements"),
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
