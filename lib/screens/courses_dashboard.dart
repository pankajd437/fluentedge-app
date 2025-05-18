import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluentedge_app/localization/app_localizations.dart';
import 'package:fluentedge_app/data/beginner_courses_list.dart';
import 'package:fluentedge_app/data/intermediate_courses_list.dart';
import 'package:fluentedge_app/data/advanced_courses_list.dart';
import 'package:fluentedge_app/screens/menu_page.dart'; // ✅ Import MenuPage
import 'package:fluentedge_app/main.dart'; // ✅ for userLevelProvider

class CoursesDashboardPage extends ConsumerStatefulWidget {
  const CoursesDashboardPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CoursesDashboardPage> createState() => _CoursesDashboardPageState();
}

class _CoursesDashboardPageState extends ConsumerState<CoursesDashboardPage> {
  final Map<String, bool> _scaleStates = {
    'achievements': false,
    'dashboard': false,
    'leaderboard': false,
    'community': false,
    'analytics': false,
  };

  late String selectedLevel;

  @override
  void initState() {
    super.initState();
    selectedLevel = ref.read(userLevelProvider); // ✅ Load from memory
  }

  void _animateButton(String key, VoidCallback action) {
    setState(() => _scaleStates[key] = true);
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() => _scaleStates[key] = false);
      action();
    });
  }

  List<Map<String, dynamic>> _getSelectedCourses() {
    switch (selectedLevel) {
      case 'intermediate':
        return intermediateCourses;
      case 'advanced':
        return advancedCourses;
      default:
        return beginnerCourses;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final routeExtra = GoRouterState.of(context).extra;
    final langPref = (routeExtra is Map && routeExtra['languagePreference'] is String)
        ? routeExtra['languagePreference'] as String
        : null;

    final bool isHindi = langPref == 'हिंदी' ||
        (langPref == null && localizations?.locale.languageCode == 'hi');

    final List<Map<String, dynamic>> selectedCourses = _getSelectedCourses();

    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FB),
      drawer: const Drawer(child: MenuPage()),

      // Gradient AppBar
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: AppBar(
          leading: Builder(
            builder: (context) {
              return Hero(
                tag: 'menuIconHero',
                child: IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              );
            },
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Text(
            isHindi ? 'आपका कोर्स डैशबोर्ड' : 'Your Personalized Course Hub',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),

            // 🎛️ Level Switcher Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _levelToggle("beginner", isHindi ? "शुरुआती" : "Beginner"),
                  const SizedBox(width: 8),
                  _levelToggle("intermediate", isHindi ? "मध्यम" : "Intermediate"),
                  const SizedBox(width: 8),
                  _levelToggle("advanced", isHindi ? "उन्नत" : "Advanced"),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 🧠 Navigation Cards (3D effect with multiple box shadows)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 2.2,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _animatedNavCard(
                    keyName: 'achievements',
                    icon: Icons.emoji_events_outlined,
                    label: isHindi ? "उपलब्धियां" : "Achievements",
                    color: Colors.deepOrange,
                    onTap: () => context.push('/achievements'),
                  ),
                  _animatedNavCard(
                    keyName: 'dashboard',
                    icon: Icons.account_circle,
                    label: isHindi ? "डैशबोर्ड" : "Dashboard",
                    color: Colors.indigo,
                    onTap: () => context.push('/userDashboard'),
                  ),
                  _animatedNavCard(
                    keyName: 'leaderboard',
                    icon: Icons.leaderboard,
                    label: isHindi ? "लीडरबोर्ड" : "Leaderboard",
                    color: Colors.teal,
                    onTap: () => context.push('/leaderboard'),
                  ),
                  _animatedNavCard(
                    keyName: 'community',
                    icon: Icons.people_alt_rounded,
                    label: isHindi ? "कम्युनिटी" : "Community",
                    color: Colors.purple,
                    onTap: () => context.push('/community'),
                  ),
                  _animatedNavCard(
                    keyName: 'analytics',
                    icon: Icons.bar_chart_rounded,
                    label: isHindi ? "एनालिटिक्स" : "Analytics",
                    color: Colors.blueGrey,
                    onTap: () => context.push('/analytics'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // 📚 Course List (replicate design from SmartCourseRecommendationPage)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: selectedCourses.length,
                itemBuilder: (context, index) {
                  final course = selectedCourses[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Row for icon + FREE/PREMIUM
                          Row(
                            children: [
                              // Optional hero tag (like in recommended page)
                              Hero(
                                tag: course["title"],
                                child: CircleAvatar(
                                  backgroundColor: course["color"].withOpacity(0.1),
                                  child: Icon(course["icon"], color: course["color"]),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: course["tag"] == "free"
                                      ? Colors.green
                                      : Colors.orange,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  course["tag"] == "free" ? "FREE" : "PREMIUM",
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Course Title
                          Text(
                            course["title"],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 6),
                          // Star Row (extra from the dashboard page)
                          Row(
                            children: const [
                              Icon(Icons.star, color: Colors.amber, size: 16),
                              Icon(Icons.star, color: Colors.amber, size: 16),
                              Icon(Icons.star, color: Colors.amber, size: 16),
                              Icon(Icons.star, color: Colors.amber, size: 16),
                              Icon(Icons.star_half, color: Colors.amber, size: 16),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Course Description
                          Text(
                            "• ${course["description"]}\n"
                            "• Engaging lessons & practical tips\n"
                            "• Expert mentors & peer community\n"
                            "• Ideal for daily practice & confidence",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // "Start Now" button (keep gradient from original)
                          Align(
                            alignment: Alignment.bottomRight,
                            child: ElevatedButton(
                              clipBehavior: Clip.antiAlias,
                              onPressed: () =>
                                  context.push('/courseDetail', extra: course),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 2,
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                shadowColor: Colors.transparent,
                              ).copyWith(
                                side: MaterialStateProperty.all(BorderSide.none),
                              ),
                              child: Ink(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF43A047), // Darker green
                                      Color(0xFF2E7D32), // Lighter green
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                  child: Text(
                                    isHindi ? "शुरू करें" : "Start Now",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(0, 2),
                                          blurRadius: 3,
                                          color: Colors.black38,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
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

  // 🔁 Level Toggle Widget (unchanged)
  Widget _levelToggle(String level, String label) {
    final bool isSelected = level == selectedLevel;
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedLevel = level;
            ref.read(userLevelProvider.notifier).state = level;
          });
        },
        style: ElevatedButton.styleFrom(
          elevation: isSelected ? 4 : 0,
          backgroundColor: isSelected ? Colors.blue : Colors.white,
          foregroundColor: isSelected ? Colors.white : Colors.blue,
          side: BorderSide(color: Colors.blue.shade300),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // 🎯 Animated Nav Card Widget (3D effect with multiple shadows)
  Widget _animatedNavCard({
    required String keyName,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isScaled = _scaleStates[keyName] ?? false;
    return AnimatedScale(
      scale: isScaled ? 0.95 : 1.0,
      duration: const Duration(milliseconds: 100),
      child: GestureDetector(
        onTap: () => _animateButton(keyName, onTap),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.9),
                color.withOpacity(0.6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            // 3D effect with multiple shadows
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(3, 3),
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.5),
                blurRadius: 4,
                offset: const Offset(-3, -3),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 2),
                      blurRadius: 3,
                      color: Colors.black38,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
