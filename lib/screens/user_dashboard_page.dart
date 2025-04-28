import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluentedge_app/constants.dart';
import 'package:fluentedge_app/data/user_state.dart';
import 'package:fluentedge_app/data/beginner_courses_list.dart';
import 'package:fluentedge_app/data/intermediate_courses_list.dart';
import 'package:fluentedge_app/data/advanced_courses_list.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

class UserDashboardPage extends StatefulWidget {
  const UserDashboardPage({super.key});

  @override
  State<UserDashboardPage> createState() => _UserDashboardPageState();
}

class _UserDashboardPageState extends State<UserDashboardPage> {
  int currentStreak = 0;
  List<Map<String, dynamic>> matchedCourses = [];
  String userName = "User";

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchStreak(); // now uses ApiConfig.local
    _loadRecommendedCourses(); // tries backend first, fallback to Hive
  }

  /// Loads user's name from local storage
  Future<void> _loadUserData() async {
    final name = await UserState.getUserName();
    if (name != null && name.isNotEmpty) {
      setState(() => userName = name);
    }
  }

  /// Fetch user streak from backend
  Future<void> _fetchStreak() async {
    final name = await UserState.getUserName() ?? 'Anonymous';
    // Switch from hardcoded 10.0.2.2:8000 to your environment var:
    final url = Uri.parse("${ApiConfig.local}/api/v1/user/streak?name=$name");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          currentStreak = data['streak'] ?? 0;
        });
      } else {
        debugPrint("❌ Failed to fetch streak: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ Failed to fetch streak: $e");
    }
  }

  /// Attempts to load recommended courses from the backend
  /// Falls back to local Hive data if needed
  Future<void> _loadRecommendedCourses() async {
    // If you have a userId stored in UserState, use that for backend calls
    final userId = await UserState.getUserId(); // or read from Hive if needed
    if (userId == null || userId.isEmpty) {
      debugPrint("⚠️ userId not found. Fallback to local recommended logic.");
      _loadRecommendedCoursesFallback();
      return;
    }

    final url = Uri.parse("${ApiConfig.local}/api/v1/user/$userId/recommendations");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Expecting data to be a list of course objects
        if (data is List) {
          setState(() {
            matchedCourses = List<Map<String, dynamic>>.from(data);
          });

          // If backend returned an empty list, fallback to local
          if (matchedCourses.isEmpty) {
            debugPrint("No recommended courses from backend. Fallback to local data.");
            _loadRecommendedCoursesFallback();
          }
        } else {
          debugPrint("Invalid recommendations format. Fallback to local data.");
          _loadRecommendedCoursesFallback();
        }
      } else {
        debugPrint("❌ Failed to fetch recommended courses: ${response.statusCode}");
        _loadRecommendedCoursesFallback();
      }
    } catch (e) {
      debugPrint("❌ Error fetching recommended courses: $e");
      _loadRecommendedCoursesFallback();
    }
  }

  /// The existing local logic to read recommended course titles from Hive,
  /// then filter out from beginner/intermediate/advanced arrays
  Future<void> _loadRecommendedCoursesFallback() async {
    final box = await Hive.openBox(kHiveBoxSettings);
    final List<dynamic>? recommended = box.get(kHiveKeyRecommendedCourses);
    final String userLevel = box.get(kHiveKeyUserLevel) ?? 'beginner';

    List<Map<String, dynamic>> allCourses = userLevel == 'intermediate'
        ? intermediateCourses
        : userLevel == 'advanced'
            ? advancedCourses
            : beginnerCourses;

    if (recommended != null && recommended.isNotEmpty) {
      final titles = recommended.cast<String>();
      setState(() {
        matchedCourses = allCourses
            .where((course) => titles.contains(course['title']))
            .toList();
      });
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
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🧠 Greeting
            Text(
              "👋 Welcome back, $userName!",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: kPrimaryIconBlue,
              ),
            ),
            const SizedBox(height: 16),

            // Streak card
            _buildStreakCard(),
            const SizedBox(height: 24),

            // Recommended courses
            if (matchedCourses.isNotEmpty) ...[
              Text(
                "🎯 Recommended Courses",
                style: TextStyle(
                  fontSize: kFontMedium,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryIconBlue,
                ),
              ),
              const SizedBox(height: 12),
              ...matchedCourses.map((course) => _buildRecommendedCard(course)).toList(),
              const SizedBox(height: 30),
            ],

            // Quick Access
            Text(
              "🚀 Quick Access",
              style: TextStyle(
                fontSize: kFontMedium,
                fontWeight: FontWeight.bold,
                color: kPrimaryIconBlue,
              ),
            ),
            const SizedBox(height: 14),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 3 / 2.6,
              children: [
                _buildShortcutTile(
                  "Achievements",
                  Icons.emoji_events_outlined,
                  Colors.amber,
                  '/achievements',
                ),
                _buildShortcutTile(
                  "Explore Courses",
                  Icons.menu_book_rounded,
                  Colors.deepPurple,
                  '/coursesDashboard',
                ),
                _buildShortcutTile(
                  "AI Mentor (Soon)",
                  Icons.smart_toy_outlined,
                  Colors.cyan,
                  '/chat',
                ),
                _buildShortcutTile(
                  "Leaderboard",
                  Icons.leaderboard,
                  Colors.pinkAccent,
                  '/leaderboard',
                ),
                _buildShortcutTile(
                  "My Analytics",
                  Icons.bar_chart_rounded,
                  Colors.blueGrey,
                  '/analytics',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakCard() {
    return Container(
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
                  color: kPrimaryIconBlue,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "🔥 $currentStreak-Day Streak",
                style: const TextStyle(
                  fontSize: 13.5,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const Icon(Icons.local_fire_department,
              color: Colors.orange, size: 34),
        ],
      ),
    );
  }

  Widget _buildRecommendedCard(Map<String, dynamic> course) {
    return GestureDetector(
      onTap: () => GoRouter.of(context).push('/courseDetail', extra: course),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: kCardBoxShadow,
        ),
        child: Row(
          children: [
            // Assuming backend or local fallback includes 'icon' & 'color'
            // Otherwise you may handle safely if missing
            Icon(course['icon'], color: course['color'], size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    course['description'],
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 18, color: kPrimaryIconBlue),
          ],
        ),
      ),
    );
  }

  Widget _buildShortcutTile(
    String title,
    IconData icon,
    Color color,
    String route,
  ) {
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
