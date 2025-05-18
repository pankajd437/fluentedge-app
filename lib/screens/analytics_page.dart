import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:fluentedge_app/constants.dart';
import 'package:http/http.dart' as http;
import 'package:fluentedge_app/data/user_state.dart';
// 🔥 NEW
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnalyticsPage extends ConsumerStatefulWidget {
  const AnalyticsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends ConsumerState<AnalyticsPage> {
  int totalXP = 0;        // from backend
  int dailyStreak = 0;    // from backend
  int totalLessons = 0;   // from backend
  Duration totalTimeSpent = const Duration(); // from backend

  @override
  void initState() {
    super.initState();
    _fetchUserXP();      // pulls from backend
    _fetchStreak();      // pulls from backend
    _fetchLessonStats(); // pulls from backend
  }

  /// Formats the Duration into "Hh Mm" for display
  String get formattedTime {
    final hours = totalTimeSpent.inHours;
    final minutes = totalTimeSpent.inMinutes.remainder(60);
    return "${hours}h ${minutes}m";
  }

  /// Fetch total XP from backend
  Future<void> _fetchUserXP() async {
    final name = await UserState.getUserName() ?? "Anonymous";
    final url = Uri.parse("${ApiConfig.local}/api/v1/user/xp?name=$name");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          totalXP = jsonData['total_xp'] ?? 0;
        });
      } else {
        debugPrint("❌ Failed to fetch XP: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ Error fetching XP: $e");
    }
  }

  /// Fetch daily streak from backend
  Future<void> _fetchStreak() async {
    final name = await UserState.getUserName() ?? "Anonymous";
    final url = Uri.parse("${ApiConfig.local}/api/v1/user/streak?name=$name");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          dailyStreak = jsonData['streak'] ?? 0;
        });
      } else {
        debugPrint("❌ Failed to fetch streak: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ Error fetching streak: $e");
    }
  }

  /// Fetch completed lessons + total time from backend
  Future<void> _fetchLessonStats() async {
    final name = await UserState.getUserName() ?? "Anonymous";
    final url = Uri.parse("${ApiConfig.local}/api/v1/user/lessons?name=$name");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          totalLessons = data['completed_lessons'] ?? 0;
          final minutes = data['minutes_spent'] ?? 0;
          totalTimeSpent = Duration(minutes: minutes);
        });
      } else {
        debugPrint("❌ Failed to fetch lesson stats: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ Error fetching lesson stats: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1) Watch local XP from xpProvider
    final localXP = ref.watch(xpProvider);

    // 2) Decide which XP to display (local or backend)
    final xpDisplayed = localXP >= totalXP ? localXP : totalXP;

    return Scaffold(
      backgroundColor: kBackgroundSoftBlue,
      appBar: AppBar(
        backgroundColor: kPrimaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "📊 Your Progress",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            // 3) Show xpDisplayed for XP stat
            _buildStatCard(
              icon: Icons.star,
              label: kXPPointsText,
              value: "$xpDisplayed XP",
              color: kAccentGreen,
              lottie: 'assets/animations/success_checkmark.json',
            ),
            const SizedBox(height: 16),
            _buildStatCard(
              icon: Icons.local_fire_department_rounded,
              label: kDailyStreakText,
              value: "$dailyStreak days 🔥",
              color: Colors.deepOrange,
              lottie: 'assets/animations/tick_animation.json',
            ),
            const SizedBox(height: 16),
            _buildStatCard(
              icon: Icons.bookmark_rounded,
              label: "Lessons Completed",
              value: "$totalLessons lessons",
              color: Colors.indigo,
              lottie: 'assets/animations/activity_correct.json',
            ),
            const SizedBox(height: 16),
            _buildStatCard(
              icon: Icons.access_time_filled,
              label: "Total Learning Time",
              value: formattedTime,
              color: Colors.blueGrey,
              lottie: 'assets/animations/task_completed.json',
            ),
          ],
        ),
      ),
    );
  }

  /// Reusable method that builds each stat row
  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required String lottie,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: color.withOpacity(0.15)),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.12),
          child: Icon(icon, color: color),
        ),
        title: Text(
          label,
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        trailing: Lottie.asset(
          lottie,
          height: 42,
          repeat: false,
        ),
      ),
    );
  }
}
