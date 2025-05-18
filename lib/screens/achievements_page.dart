import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:fluentedge_app/constants.dart';
import 'package:go_router/go_router.dart';
import 'package:fluentedge_app/data/user_state.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

class AchievementsPage extends ConsumerStatefulWidget {
  const AchievementsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends ConsumerState<AchievementsPage> {
  int streak = 0;
  int completedLessons = 0;

  // Existing local XP field (fallback from older logic)
  int totalXP = 0; 

  @override
  void initState() {
    super.initState();
    _fetchStreak();
    _fetchCompletedLessons();
    _fetchUserXP(); // 🆕 fetch from /api/v1/user/xp, then sync into xpProvider
  }

  /// Fetch daily streak from the backend; fallback if needed
  Future<void> _fetchStreak() async {
    final name = await UserState.getUserName() ?? "Anonymous";
    final url = Uri.parse("${ApiConfig.local}/api/v1/user/streak?name=$name");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          streak = data['streak'] ?? 0;
        });
      } else {
        debugPrint("❌ Failed to fetch streak (status: ${response.statusCode}).");
      }
    } catch (e) {
      debugPrint("❌ Failed to fetch streak: $e");
    }
  }

  /// Attempt to fetch completed lessons from backend
  /// If something goes wrong, fallback to local Hive approach
  Future<void> _fetchCompletedLessons() async {
    final name = await UserState.getUserName() ?? "Anonymous";
    final url = Uri.parse("${ApiConfig.local}/api/v1/user/lessons?name=$name");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final int fetchedCount = data['completed_lessons'] ?? 0;
        setState(() {
          completedLessons = fetchedCount;
        });
      } else {
        debugPrint(
            "❌ Failed to fetch lesson stats (status: ${response.statusCode}). Fallback to local.");
        _countCompletedLessonsLocal();
      }
    } catch (e) {
      debugPrint("❌ Error fetching lesson stats: $e. Fallback to local.");
      _countCompletedLessonsLocal();
    }
  }

  /// Local fallback: read from Hive box
  Future<void> _countCompletedLessonsLocal() async {
    final box = await Hive.openBox(kHiveBoxCompletedLessons);
    final keys = box.keys.toList();
    setState(() {
      completedLessons = keys.length;
    });
    debugPrint("📘 [Fallback] Completed Lessons (local Hive): $completedLessons");
  }

  /// 🆕 New method to fetch real total XP from /api/v1/user/xp
  /// and sync with xpProvider so we display real-time local XP
  Future<void> _fetchUserXP() async {
    final name = await UserState.getUserName() ?? "Anonymous";
    final url = Uri.parse("${ApiConfig.local}/api/v1/user/xp?name=$name");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final serverXP = data['total_xp'] ?? 0;

        // Keep old local state field for fallback
        setState(() {
          totalXP = serverXP;
        });

        // 🆕 If server XP is greater than local XP, update xpProvider
        final localXP = ref.read(xpProvider); 
        if (serverXP > localXP) {
          ref.read(xpProvider.notifier).setXP(serverXP);
          debugPrint("🌐 [Achievements] Server XP $serverXP is higher; updating local to match.");
        } else {
          debugPrint("🌐 [Achievements] Local XP is higher or equal, ignoring server XP.");
        }
      } else {
        debugPrint("❌ Failed to fetch XP: ${response.statusCode} => ${response.body}");
      }
    } catch (e) {
      debugPrint("❌ Error fetching XP: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🆕 Instead of showing local `totalXP` from the server call,
    // we watch xpProvider for real-time XP across the app.
    final currentXP = ref.watch(xpProvider);

    // Local badges array, referencing the streak and completedLessons
    final List<Map<String, dynamic>> badges = [
      {
        "title": "Lesson Starter",
        "animation": "assets/animations/badges/lesson_completion_badge.json",
        "unlocked": completedLessons >= 1,
        "tag": "lesson_1",
        "xp": 100,
      },
      {
        "title": "5 Lessons Completed",
        "animation": "assets/animations/badges/quiz_champion_badge.json",
        "unlocked": completedLessons >= 5,
        "tag": "lesson_5",
        "xp": 300,
      },
      {
        "title": "10 Lessons Completed",
        "animation": "assets/animations/badges/fast_learner_badge.json",
        "unlocked": completedLessons >= 10,
        "tag": "lesson_10",
        "xp": 600,
      },
      {
        "title": "25 Lessons Completed",
        "animation": "assets/animations/badges/perfect_score_badge.json",
        "unlocked": completedLessons >= 25,
        "tag": "lesson_25",
        "xp": 1200,
      },
      {
        "title": "🔥 3-Day Streak",
        "animation": "assets/animations/badges/daily_streak_badge.json",
        "unlocked": streak >= 3,
        "tag": "streak_3",
        "xp": 100,
      },
      {
        "title": "🔥 7-Day Streak",
        "animation": "assets/animations/badges/fast_learner_badge.json",
        "unlocked": streak >= 7,
        "tag": "streak_7",
        "xp": 300,
      },
      {
        "title": "🔥 14-Day Streak",
        "animation": "assets/animations/badges/quiz_champion_badge.json",
        "unlocked": streak >= 14,
        "tag": "streak_14",
        "xp": 600,
      },
      {
        "title": "🔥 30-Day Streak",
        "animation": "assets/animations/badges/perfect_score_badge.json",
        "unlocked": streak >= 30,
        "tag": "streak_30",
        "xp": 1500,
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
            onPressed: () => GoRouter.of(context).go(routeCoursesDashboard),
          )
        ],
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
                onPressed: () => GoRouter.of(context).go(routeCoursesDashboard),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🆕 Show real-time XP (from xpProvider)
            Text(
              "Your Total XP: $currentXP",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: kAccentGreen,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "🎖 Your Badges",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: kPrimaryIconBlue,
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: GridView.builder(
                itemCount: badges.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  final badge = badges[index];
                  final unlocked = badge['unlocked'];
                  final animation = badge['animation'];
                  final title = badge['title'];
                  final tag = badge['tag'];
                  final xp = badge['xp'];

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
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: EdgeInsets.zero,
                        child: Container(
                          constraints: const BoxConstraints(minHeight: 160),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: unlocked ? Colors.white : Colors.grey.shade100,
                            border: Border.all(
                              color: unlocked
                                  ? kAccentGreen
                                  : Colors.grey.shade300,
                            ),
                            borderRadius: BorderRadius.circular(16),
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
                                      value: unlocked
                                          ? null
                                          : Colors.grey.shade400,
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
                              const SizedBox(height: 6),
                              if (unlocked)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.bolt_rounded,
                                        size: 14, color: Colors.orange),
                                    const SizedBox(width: 4),
                                    Text(
                                      "$xp XP",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.orange,
                                      ),
                                    ),
                                  ],
                                ),
                              if (unlocked)
                                Lottie.asset(
                                  'assets/animations/badge_unlocked.json',
                                  height: 34,
                                  repeat: false,
                                ),
                            ],
                          ),
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
