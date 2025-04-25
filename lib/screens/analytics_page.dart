import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:fluentedge_app/constants.dart';
import 'package:http/http.dart' as http;
import 'package:fluentedge_app/data/user_state.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({Key? key}) : super(key: key);

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  int totalXP = 0;
  int dailyStreak = 0;
  int totalLessons = 0;
  Duration totalTimeSpent = const Duration(); // Placeholder

  @override
  void initState() {
    super.initState();
    _fetchUserXP();
    _fetchStreak();
    _fetchLessonStats();
  }

  String get formattedTime {
    final hours = totalTimeSpent.inHours;
    final minutes = totalTimeSpent.inMinutes.remainder(60);
    return "${hours}h ${minutes}m";
  }

  Future<void> _fetchUserXP() async {
    final name = await UserState.getUserName() ?? "Anonymous";
    final url = Uri.parse("http://10.0.2.2:8000/api/v1/user/xp?name=$name");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        setState(() {
          totalXP = json['total_xp'] ?? 0;
        });
      } else {
        debugPrint("❌ Failed to fetch XP: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ Error fetching XP: $e");
    }
  }

  Future<void> _fetchStreak() async {
    final name = await UserState.getUserName() ?? "Anonymous";
    final url = Uri.parse("http://10.0.2.2:8000/api/v1/user/streak?name=$name");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        setState(() {
          dailyStreak = json['streak'] ?? 0;
        });
      } else {
        debugPrint("❌ Failed to fetch streak: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ Error fetching streak: $e");
    }
  }

  Future<void> _fetchLessonStats() async {
    final name = await UserState.getUserName() ?? "Anonymous";
    final url = Uri.parse("http://10.0.2.2:8000/api/v1/user/lessons?name=$name");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          totalLessons = data['completed_lessons'] ?? 0;
          int minutes = data['minutes_spent'] ?? 0;
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
            _buildStatCard(
              icon: Icons.star,
              label: kXPPointsText,
              value: "$totalXP XP",
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
