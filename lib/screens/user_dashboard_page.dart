import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluentedge_app/constants.dart';
import 'package:fluentedge_app/data/user_state.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserDashboardPage extends StatefulWidget {
  const UserDashboardPage({super.key});

  @override
  State<UserDashboardPage> createState() => _UserDashboardPageState();
}

class _UserDashboardPageState extends State<UserDashboardPage> {
  int currentStreak = 0;

  @override
  void initState() {
    super.initState();
    _fetchStreak();
  }

  Future<void> _fetchStreak() async {
    final name = await UserState.getUserName() ?? 'Anonymous';
    final url = Uri.parse("http://10.0.2.2:8000/api/v1/user/streak?name=$name");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          currentStreak = data['streak'] ?? 0;
        });
      }
    } catch (e) {
      debugPrint("❌ Failed to fetch streak: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundSoftBlue,
      appBar: AppBar(
        title: const Text("🏠 Dashboard"),
        backgroundColor: kPrimaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).pop(),
        ),
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
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        kDailyStreakText,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryIconBlue),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "🔥 $currentStreak-Day Streak",
                        style: const TextStyle(
                            fontSize: 13.5, color: Colors.black87),
                      ),
                    ],
                  ),
                  const Icon(Icons.local_fire_department,
                      color: Colors.orange, size: 32)
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
                GoRouter.of(context).push('/lessonPage', extra: {
                  "courseId": "course_001",
                  "title": "Speak English Fluently",
                  "icon": Icons.record_voice_over,
                  "color": Colors.orange,
                  "tag": "free",
                  "description":
                      "Still hesitating while speaking? Start fluently handling daily conversations now.",
                  "lessons": [
                    {
                      "lessonId": "course_001_lesson_001",
                      "title": "Course Introduction & Goals"
                    },
                    {
                      "lessonId": "course_001_lesson_002",
                      "title": "Basic Vocabulary & Key Phrases"
                    },
                    {
                      "lessonId": "course_001_lesson_003",
                      "title": "Role-Play and Practice"
                    }
                  ]
                });
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
                childAspectRatio: 3 / 2.6,
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
                    route: '/leaderboard',
                  ),
                  _buildShortcutTile(
                    context,
                    title: "My Analytics",
                    icon: Icons.bar_chart_rounded,
                    color: Colors.blueGrey,
                    route: '/analytics',
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
      onTap: () => GoRouter.of(context).push(route),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.2),
              Colors.white.withOpacity(0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 36),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
