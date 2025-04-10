import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:fluentedge_app/constants.dart';
import 'package:go_router/go_router.dart';
import 'package:fluentedge_app/data/user_state.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hive/hive.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({Key? key}) : super(key: key);

  @override
  State<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  int streak = 0;
  int completedLessons = 0;

  @override
  void initState() {
    super.initState();
    _fetchStreak();
    _countCompletedLessons();
  }

  Future<void> _fetchStreak() async {
    final name = await UserState.getUserName() ?? "Anonymous";
    final url = Uri.parse("http://10.0.2.2:8000/api/v1/user/streak?name=$name");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          streak = data['streak'] ?? 0;
        });
      }
    } catch (e) {
      debugPrint("❌ Failed to fetch streak: $e");
    }
  }

  Future<void> _countCompletedLessons() async {
    final box = await Hive.openBox('completed_lessons');
    final keys = box.keys.toList();
    setState(() {
      completedLessons = keys.length;
    });

    debugPrint("📘 Total Completed Lessons: $completedLessons");
    debugPrint("📘 Lesson IDs: $keys");
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> _badges = [
      {
        "title": "Lesson Completion",
        "animation": "assets/animations/badges/lesson_completion_badge.json",
        "unlocked": true,
        "tag": "completion_badge"
      },
      {
        "title": "Mastery Badge",
        "animation": "assets/animations/badges/course_mastery_badge.json",
        "unlocked": true,
        "tag": "mastery_badge"
      },
      {
        "title": "🔥 3-Day Streak",
        "animation": "assets/animations/badges/daily_streak_badge.json",
        "unlocked": streak >= 3,
        "tag": "streak_3"
      },
      {
        "title": "🔥 7-Day Streak",
        "animation": "assets/animations/badges/fast_learner_badge.json",
        "unlocked": streak >= 7,
        "tag": "streak_7"
      },
      {
        "title": "🔥 14-Day Streak",
        "animation": "assets/animations/badges/quiz_champion_badge.json",
        "unlocked": streak >= 14,
        "tag": "streak_14"
      },
      {
        "title": "🔥 30-Day Streak",
        "animation": "assets/animations/badges/perfect_score_badge.json",
        "unlocked": streak >= 30,
        "tag": "streak_30"
      },
      {
        "title": "📚 5 Lessons Completed",
        "animation": "assets/animations/badges/quiz_champion_badge.json",
        "unlocked": completedLessons >= 5,
        "tag": "lesson_5"
      },
      {
        "title": "📚 10 Lessons Completed",
        "animation": "assets/animations/badges/fast_learner_badge.json",
        "unlocked": completedLessons >= 10,
        "tag": "lesson_10"
      },
      {
        "title": "📚 25 Lessons Completed",
        "animation": "assets/animations/badges/perfect_score_badge.json",
        "unlocked": completedLessons >= 25,
        "tag": "lesson_25"
      },
    ];

    return Scaffold(
      backgroundColor: kBackgroundSoftBlue,
      appBar: AppBar(
        title: const Text("🏅 Achievements"),
        backgroundColor: kPrimaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).pop(),
        ),
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
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  final badge = _badges[index];
                  final unlocked = badge['unlocked'];
                  final animation = badge['animation'];
                  final title = badge['title'];
                  final tag = badge['tag'];

                  return Hero(
                    tag: tag,
                    child: GestureDetector(
                      onTap: () {
                        GoRouter.of(context).push('/badgeDetail', extra: {
                          'title': title,
                          'image': animation,
                          'unlocked': unlocked,
                          'tag': tag,
                        });
                      },
                      child: Container(
                        constraints: const BoxConstraints(minHeight: 160),
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
                            Lottie.asset(
                              animation,
                              height: 56,
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
                            const SizedBox(height: 10),
                            Text(
                              title,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
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
                                height: 32,
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
