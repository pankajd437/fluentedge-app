import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:fluentedge_app/constants.dart';
import 'package:go_router/go_router.dart';

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> _badges = const [
    {
      "title": "Lesson Completion",
      "image": kBadgeCompletionPath,
      "unlocked": true,
      "tag": "completion_badge"
    },
    {
      "title": "Mastery Badge",
      "image": kBadgeMasteryPath,
      "unlocked": true,
      "tag": "mastery_badge"
    },
    {
      "title": "Streak Badge",
      "image": "assets/images/badges/streak_badge.png",
      "unlocked": false,
      "tag": "streak_badge"
    },
    {
      "title": "Quiz Champion",
      "image": "assets/images/badges/quiz_badge.png",
      "unlocked": false,
      "tag": "quiz_badge"
    },
    {
      "title": "Daily Learner",
      "image": "assets/images/badges/daily_badge.png",
      "unlocked": false,
      "tag": "daily_badge"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundSoftBlue,
      appBar: AppBar(
        title: const Text("🏅 Achievements"),
        backgroundColor: kPrimaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => GoRouter.of(context).go('/coursesDashboard'),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "🎖 Your Badges",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: kPrimaryIconBlue,
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: GridView.builder(
                itemCount: _badges.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: kGridCrossAxisCount,
                  childAspectRatio: kGridChildAspectRatio,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  final badge = _badges[index];
                  final unlocked = badge['unlocked'];
                  final image = badge['image'];
                  final title = badge['title'];
                  final tag = badge['tag'];

                  return Hero(
                    tag: tag,
                    child: GestureDetector(
                      onTap: () {
                        GoRouter.of(context).push('/badgeDetail', extra: {
                          'title': title,
                          'image': image,
                          'unlocked': unlocked,
                          'tag': tag,
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: unlocked ? Colors.white : Colors.grey.shade100,
                          border: Border.all(
                            color: unlocked ? kAccentGreen : Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: unlocked
                              ? [
                                  BoxShadow(
                                    color: kAccentGreen.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  )
                                ]
                              : [],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              image,
                              height: 60,
                              width: 60,
                              color: unlocked ? null : Colors.grey.shade400,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: unlocked ? Colors.black87 : Colors.grey,
                              ),
                            ),
                            if (unlocked) ...[
                              const SizedBox(height: 8),
                              Lottie.asset(
                                'assets/animations/badge_unlocked.json',
                                height: 36,
                                repeat: false,
                              ),
                            ]
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
    );
  }
}
