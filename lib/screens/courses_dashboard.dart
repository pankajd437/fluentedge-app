import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluentedge_app/localization/app_localizations.dart';
import 'package:fluentedge_app/data/courses_list.dart';

class CoursesDashboardPage extends StatefulWidget {
  const CoursesDashboardPage({Key? key}) : super(key: key);

  @override
  State<CoursesDashboardPage> createState() => _CoursesDashboardPageState();
}

class _CoursesDashboardPageState extends State<CoursesDashboardPage> {
  final Map<String, bool> _scaleStates = {
    'achievements': false,
    'dashboard': false,
    'leaderboard': false,
    'community': false,
    'analytics': false, // ✅ NEW
  };

  void _animateButton(String key, VoidCallback action) {
    setState(() => _scaleStates[key] = true);
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() => _scaleStates[key] = false);
      action();
    });
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

    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FB),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => context.go('/welcome'),
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
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),

            // 📘 Resume Questionnaire
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: InkWell(
                onTap: () => context.go('/questionnaire'),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFE3F2FD), Color(0xFFB3E5FC)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Text(
                    isHindi
                        ? 'क्या आप पर्सनल सुझाव चाहते हैं? प्रश्नावली फिर से शुरू करें।'
                        : 'Not sure where to start? Resume questionnaire →',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF0D47A1),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ✨ Animated Grid Buttons
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

            // 🧠 Featured Courses Section Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text(
                    isHindi ? '✨ प्रमुख कोर्स' : "✨ Featured Courses",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 🧩 Courses List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.12),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.blue.shade100,
                                child: Icon(course["icon"], color: course["color"], size: 22),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      course["title"],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13.5,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: course["tag"] == "free"
                                            ? Colors.green.shade100
                                            : Colors.orange.shade100,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        course["tag"] == "free" ? "FREE" : "PREMIUM",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: course["tag"] == "free"
                                              ? Colors.green.shade700
                                              : Colors.orange.shade700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  context.push('/courseDetail', extra: course);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF43A047),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 2,
                                ),
                                child: Text(
                                  isHindi ? "शुरू करें" : "Start Now",
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            course["description"],
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: Colors.black87,
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
              colors: [color.withOpacity(0.8), color.withOpacity(0.6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
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
                  fontSize: 13,
                  fontWeight: FontWeight.w700, // ✅ Improved
                  shadows: [
                    Shadow(
                      color: Colors.black38,
                      offset: Offset(0, 1),
                      blurRadius: 2,
                    )
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
