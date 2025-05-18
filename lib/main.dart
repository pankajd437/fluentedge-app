import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:go_router/go_router.dart';

import 'package:fluentedge_app/constants.dart'; // Make sure routeRegistration = "/registration"
import 'package:fluentedge_app/data/user_state.dart'; 
import 'package:fluentedge_app/services/notification_service.dart';
import 'package:fluentedge_app/localization/app_localizations.dart';

// Screens
import 'package:fluentedge_app/screens/splash_page.dart';
import 'package:fluentedge_app/screens/welcome_page.dart';
import 'package:fluentedge_app/screens/registration_page.dart';
import 'package:fluentedge_app/screens/profiling_chat_page.dart';
import 'package:fluentedge_app/screens/smart_course_recommendation_page.dart';
import 'package:fluentedge_app/screens/courses_dashboard.dart';
import 'package:fluentedge_app/screens/course_detail_page.dart';
import 'package:fluentedge_app/screens/lesson_page.dart';
import 'package:fluentedge_app/screens/lesson_complete_page.dart';
import 'package:fluentedge_app/screens/ice_breaking_chat.dart';
import 'package:fluentedge_app/screens/achievements_page.dart';
import 'package:fluentedge_app/screens/badge_detail_page.dart';
import 'package:fluentedge_app/screens/user_dashboard_page.dart';
import 'package:fluentedge_app/screens/leaderboard_page.dart';
import 'package:fluentedge_app/screens/community_page.dart';
import 'package:fluentedge_app/screens/friend_detail_page.dart';
import 'package:fluentedge_app/screens/analytics_page.dart';
import 'package:fluentedge_app/screens/menu_page.dart';

// Newly imported pages
import 'package:fluentedge_app/screens/skill_check_page.dart';
import 'package:fluentedge_app/screens/profiling_result_page.dart';

// ✅ Import the new login page
import 'package:fluentedge_app/screens/login_page.dart';

// Riverpod providers
final localeProvider = StateProvider<Locale>((ref) => const Locale('en'));
final userNameProvider = StateProvider<String>((ref) => '');
final languagePrefProvider = StateProvider<String>((ref) => 'English');
final userLevelProvider = StateProvider<String>((ref) => 'beginner');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // 1) Initialize local user data (loads XP, userName, isGuest from Hive)
  await UserState.init();

  // 2) If user is not guest, load streak/XP/lessons from backend
  if (!UserState.instance.isGuest) {
    await UserState.instance.loadUserProgressFromBackend();
  }

  // 3) Initialize notifications
  await NotificationService.init();

  // Read stored values for the Riverpod overrides
  final storedLocale = await UserState.getLocale() ?? 'en';
  final storedName = await UserState.getUserName() ?? '';
  final storedLang = await UserState.getLanguagePreference() ?? 'English';
  final storedLevel = await UserState.getUserLevel();

  // ⚡ NEW: Create an instance of XPNotifier, initializing from the current UserState totalXP
  final xpNotifier = XPNotifier();
  xpNotifier.setXP(UserState.instance.totalXP);

  runApp(
    ProviderScope(
      overrides: [
        // Provide your xpNotifier to the xpProvider globally
        xpProvider.overrideWith((ref) => xpNotifier),

        // Existing overrides for locale and user details
        localeProvider.overrideWith((_) => Locale(storedLocale)),
        userNameProvider.overrideWith((_) => storedName),
        languagePrefProvider.overrideWith((_) => storedLang),
        userLevelProvider.overrideWith((_) => storedLevel),
      ],
      child: FluentEdgeApp(initialLocale: Locale(storedLocale)),
    ),
  );
}

class FluentEdgeApp extends ConsumerStatefulWidget {
  final Locale initialLocale;
  const FluentEdgeApp({Key? key, required this.initialLocale}) : super(key: key);

  static Future<void> updateLocale(WidgetRef ref, Locale newLocale) async {
    await UserState.setLocale(newLocale.languageCode);
    ref.read(localeProvider.notifier).state = newLocale;
  }

  @override
  ConsumerState<FluentEdgeApp> createState() => _FluentEdgeAppState();
}

class _FluentEdgeAppState extends ConsumerState<FluentEdgeApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = _setupRouter();
  }

  GoRouter _setupRouter() {
    return GoRouter(
      initialLocation: routeWelcome,
      routes: [
        // 1) WELCOME PAGE
        GoRoute(
          path: routeWelcome,
          builder: (_, __) => WelcomePage(
            onUserInfoSubmitted: (name, lang) async {
              await UserState.setUserName(name);
              await UserState.setLanguagePreference(lang);
              ref.read(userNameProvider.notifier).state = name;
              ref.read(languagePrefProvider.notifier).state = lang;

              // Navigate to Registration
              Future.microtask(() {
                _router.go(routeRegistration, extra: {'name': name});
              });
            },
          ),
        ),

        // 2) REGISTRATION PAGE
        GoRoute(
          path: routeRegistration,
          builder: (context, state) {
            final name = (state.extra as Map<String, dynamic>?)?['name'] ?? '';
            return RegistrationPage(prefilledName: name);
          },
        ),

        // 3) PROFILING PAGE
        GoRoute(
          path: routeProfilingChat,
          builder: (_, __) => const ProfilingChatPage(),
        ),

        // 4) PROFILING RESULT (first usage)
        GoRoute(
          path: routeProfilingResult,
          builder: (context, state) {
            final args = state.extra as Map<String, dynamic>? ?? {};
            debugPrint("DEBUG => Going to ProfilingResultPage with userLevel=${args['userLevel']}");
            debugPrint("DEBUG => recommendedCourses=${args['recommendedCourses']}");

            return ProfilingResultPage(
              score: args['score'],
              total: args['totalQuestions'],
              userName: args['userName'],
              languagePreference: args['languagePreference'],
              gender: args['gender'],
              age: args['age'],
              recommendedCourses: List<String>.from(args['recommendedCourses'] ?? []),
              userLevel: args['userLevel'] ?? 'beginner',
            );
          },
        ),

        // 5) COURSE RECOMMENDATIONS
        GoRoute(
          path: routeCourseRecommendations,
          builder: (context, state) {
            final data = state.extra as Map<String, dynamic>? ?? {};
            debugPrint("DEBUG => Going to SmartCourseRecommendation with userLevel=${data['userLevel']}");
            debugPrint("DEBUG => recommendedCourses=${data['recommendedCourses']}");

            return SmartCourseRecommendationPage(
              userName: data['userName'],
              languagePreference: data['languagePreference'],
              gender: data['gender'],
              age: data['age'],
              recommendedCourses: List<String>.from(data['recommendedCourses'] ?? []),
              userLevel: data['userLevel'] ?? 'beginner',
            );
          },
        ),

        // 6) COURSES DASHBOARD
        GoRoute(
          path: routeCoursesDashboard,
          builder: (_, __) => const CoursesDashboardPage(),
        ),

        // 7) COURSE DETAIL PAGE
        GoRoute(
          path: routeCourseDetail,
          pageBuilder: (_, state) {
            final course = state.extra as Map<String, dynamic>?;
            return CustomTransitionPage(
              transitionDuration: kPageTransitionDuration,
              transitionsBuilder: (_, animation, __, child) =>
                  FadeTransition(opacity: animation, child: child),
              child: course != null
                  ? CourseDetailPage(course: course)
                  : const Scaffold(
                      body: Center(child: Text("❌ Invalid course data.")),
                    ),
            );
          },
        ),

        // 8) LESSON PAGE
        GoRoute(
          path: routeLessonPage,
          pageBuilder: (_, state) {
            final course = state.extra as Map<String, dynamic>?;
            return CustomTransitionPage(
              transitionDuration: kPageTransitionDuration,
              transitionsBuilder: (_, animation, __, child) =>
                  FadeTransition(opacity: animation, child: child),
              child: course != null
                  ? LessonPage(
                      courseTitle: course['title'],
                      courseIcon: course['icon'],
                      courseColor: course['color'],
                      lessons: List<Map<String, String>>.from(course['lessons']),
                    )
                  : const Scaffold(
                      body: Center(child: Text("❌ Invalid lesson data.")),
                    ),
            );
          },
        ),

        // 9) LESSON COMPLETE PAGE
        GoRoute(
          path: routeLessonComplete,
          pageBuilder: (_, state) {
            final data = state.extra as Map<String, dynamic>?;
            return CustomTransitionPage(
              transitionDuration: kPageTransitionDuration,
              transitionsBuilder: (_, animation, __, child) =>
                  FadeTransition(opacity: animation, child: child),
              child: data != null
                  ? LessonCompletePage(
                      lessonId: data['lessonId'],
                      lessonTitle: data['lessonTitle'],
                      earnedXP: data['earnedXP'],
                      badgeId: data['badgeId'],
                      isCorrect: data['isCorrect'] ?? true,
                    )
                  : const Scaffold(
                      body: Center(child: Text("❌ Lesson data missing.")),
                    ),
            );
          },
        ),

        // 10) OTHER ROUTES...
        GoRoute(
          path: routeAchievements,
          builder: (_, __) => const AchievementsPage(),
        ),
        GoRoute(
          path: routeUserDashboard,
          builder: (_, __) => const UserDashboardPage(),
        ),
        GoRoute(
          path: routeLeaderboard,
          builder: (_, __) => const LeaderboardPage(),
        ),
        GoRoute(
          path: routeCommunity,
          builder: (_, __) => const CommunityPage(),
        ),
        GoRoute(
          path: routeFriendDetail,
          pageBuilder: (_, state) {
            final data = state.extra as Map<String, dynamic>?;
            return CustomTransitionPage(
              transitionDuration: kPageTransitionDuration,
              transitionsBuilder: (_, animation, __, child) =>
                  FadeTransition(opacity: animation, child: child),
              child: data != null
                  ? FriendDetailPage(
                      friendName: data['friendName'],
                      avatarEmoji: data['avatarEmoji'],
                      xp: data['xp'],
                      badges: List<Map<String, dynamic>>.from(data['badges']),
                    )
                  : const Scaffold(
                      body: Center(child: Text("❌ Friend data missing.")),
                    ),
            );
          },
        ),
        GoRoute(
          path: routeBadgeDetail,
          pageBuilder: (_, state) {
            final badge = state.extra as Map<String, dynamic>?;
            return CustomTransitionPage(
              transitionDuration: kPageTransitionDuration,
              transitionsBuilder: (_, animation, __, child) =>
                  FadeTransition(opacity: animation, child: child),
              child: badge != null
                  ? BadgeDetailPage(
                      title: badge['title'],
                      imagePath: badge['image'],
                      unlocked: badge['unlocked'],
                      tag: badge['tag'],
                    )
                  : const Scaffold(
                      body: Center(child: Text("❌ Badge data missing.")),
                    ),
            );
          },
        ),
        GoRoute(path: routeAnalytics, builder: (_, __) => const AnalyticsPage()),
        GoRoute(path: routeMenu, builder: (_, __) => const MenuPage()),
        GoRoute(
          path: routeChat,
          builder: (_, __) => IceBreakingChatPage(
            userName: ref.watch(userNameProvider),
            languagePreference: ref.watch(languagePrefProvider),
          ),
        ),

        // ✅ SkillCheck Route with correct arguments
        GoRoute(
          path: routeSkillCheck, // e.g., "/skillCheck"
          builder: (context, state) {
            final data = state.extra as Map<String, dynamic>? ?? {};
            return SkillCheckPage(
              userName: data['userName'],
              languagePreference: data['languagePreference'],
              gender: data['gender'],
              age: data['age'],
              recommendedCourses: List<String>.from(data['recommendedCourses'] ?? []),
              userLevel: data['userLevel'] ?? 'beginner',
            );
          },
        ),

        // Final 'ProfilingResult' route with additional data (2nd usage)
        GoRoute(
          path: routeProfilingResult,
          builder: (context, state) {
            final args = state.extra as Map<String, dynamic>? ?? {};
            debugPrint("DEBUG => (Second usage) ProfilingResult with userLevel=${args['userLevel']}");
            debugPrint("DEBUG => recommendedCourses=${args['recommendedCourses']}");

            return ProfilingResultPage(
              score: args['score'],
              total: args['totalQuestions'],
              userName: args['userName'],
              languagePreference: args['languagePreference'],
              gender: args['gender'],
              age: args['age'],
              recommendedCourses: List<String>.from(args['recommendedCourses'] ?? []),
              userLevel: args['userLevel'] ?? 'beginner',
            );
          },
        ),

        // ✅ NEW LOGIN ROUTE (for returning users)
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
      ],
    );
  }

  /// Placeholder method for building a default 'profiling result' screen
  /// if you needed it without extra data.
  Widget _buildProfilingResultPage(Map<String, dynamic> data) {
    final recommendedCourses = data['recommended_courses'];
    final coursesList = recommendedCourses is List<dynamic>
        ? List<String>.from(recommendedCourses)
        : <String>[];

    return Scaffold(
      appBar: AppBar(title: const Text("Profiling Result")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Name: ${data['userName']}"),
              Text("Language: ${data['languagePreference']}"),
              Text("Gender: ${data['gender']}"),
              Text("Age: ${data['age']}"),
              Text("User Level: ${data['userLevel']}"),
              const SizedBox(height: 16),
              const Text(
                "Recommended Courses:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              for (final c in coursesList) Text("- $c"),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'FluentEdge',
      debugShowCheckedModeBanner: false,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('hi')],
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: kBackgroundSoftBlue,
        colorScheme: const ColorScheme.light(
          primary: kPrimaryBlue,
          secondary: kAccentGreen,
        ),
        textTheme: kAppTextTheme,
      ),
      darkTheme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: kDarkBackground,
        colorScheme: const ColorScheme.dark(
          primary: kDarkPrimaryBlue,
          secondary: kDarkAccentGreen,
        ),
        textTheme: kAppTextTheme,
      ),
      routerConfig: _router,
    );
  }
}
