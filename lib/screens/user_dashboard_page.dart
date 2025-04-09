import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluentedge_app/constants.dart';

class UserDashboardPage extends StatelessWidget {
  const UserDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundSoftBlue,
      appBar: AppBar(
        title: const Text("🏠 Dashboard"),
        backgroundColor: kPrimaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Future: Open settings
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🎯 XP & Streak Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: kCardBoxShadow,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(kDailyStreakText,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: kPrimaryIconBlue)),
                      SizedBox(height: 6),
                      Text("🔥 5-Day Streak | 875 XP",
                          style: TextStyle(fontSize: 13.5, color: Colors.black87)),
                    ],
                  ),
                  Icon(Icons.local_fire_department, color: Colors.orange, size: 32)
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 🧩 Resume Lesson CTA
            Text("🎓 Continue Learning",
                style: TextStyle(
                    fontSize: kFontMedium,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryIconBlue)),

            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                GoRouter.of(context).go('/lessonPage');
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: kPrimaryGradient,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: kCardBoxShadow,
                ),
                child: Row(
                  children: const [
                    Icon(Icons.play_circle_fill, color: Colors.white, size: 28),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Resume: Speak English Fluently",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 🎖 Shortcut Grid
            Text("🚀 Quick Access",
                style: TextStyle(
                    fontSize: kFontMedium,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryIconBlue)),

            const SizedBox(height: 14),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 3 / 2.4,
                children: [
                  _buildShortcutTile(
                    context,
                    title: "Achievements",
                    icon: Icons.emoji_events_outlined,
                    color: Colors.amber,
                    route: '/achievements',
                  ),
                  _buildShortcutTile(
                    context,
                    title: "Explore Courses",
                    icon: Icons.menu_book_rounded,
                    color: Colors.deepPurple,
                    route: '/coursesDashboard',
                  ),
                  _buildShortcutTile(
                    context,
                    title: "AI Mentor (Soon)",
                    icon: Icons.smart_toy_outlined,
                    color: Colors.cyan,
                    route: '/chat',
                  ),
                  _buildShortcutTile(
                    context,
                    title: "Leaderboard",
                    icon: Icons.leaderboard,
                    color: Colors.pinkAccent,
                    route: '/leaderboardPage', // Placeholder for future
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShortcutTile(BuildContext context,
      {required String title,
      required IconData icon,
      required Color color,
      required String route}) {
    return GestureDetector(
      onTap: () {
        GoRouter.of(context).go(route);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.2)),
          boxShadow: kCardBoxShadow,
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 10),
            Text(title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                )),
          ],
        ),
      ),
    );
  }
}
