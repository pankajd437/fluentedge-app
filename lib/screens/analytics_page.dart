import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:fluentedge_app/constants.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({Key? key}) : super(key: key);

  // 🔢 Mocked user stats (replace with backend in future)
  final int totalXP = 820;
  final int totalLessons = 14;
  final int dailyStreak = 5;
  final Duration totalTimeSpent = Duration(minutes: 146); // 2h 26m

  String get formattedTime {
    final hours = totalTimeSpent.inHours;
    final minutes = totalTimeSpent.inMinutes.remainder(60);
    return "${hours}h ${minutes}m";
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
        child: Column(
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
        border: Border.all(color: color.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
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
          height: 40,
          repeat: false,
        ),
      ),
    );
  }
}
