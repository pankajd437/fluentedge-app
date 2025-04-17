import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:go_router/go_router.dart';

import 'package:fluentedge_app/constants.dart';
import 'package:fluentedge_app/data/user_state.dart';
import 'package:fluentedge_app/services/notification_service.dart';
import 'package:fluentedge_app/localization/app_localizations.dart';

// Onboarding screens
import 'package:fluentedge_app/screens/splash_page.dart';
import 'package:fluentedge_app/screens/welcome_page.dart';
import 'package:fluentedge_app/screens/registration_page.dart';
import 'package:fluentedge_app/screens/profiling_chat_page.dart';
import 'package:fluentedge_app/screens/skill_check_page.dart';
import 'package:fluentedge_app/screens/smart_course_recommendation_page.dart';

// Other app screens
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

/// Providers for global state
final localeProvider       = StateProvider<Locale>((ref) => const Locale('en'));
final userNameProvider     = StateProvider<String>((ref) => '');
final languagePrefProvider = StateProvider<String>((ref) => 'English');
final userLevelProvider    = StateProvider<String>((ref) => 'beginner');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await UserState.init();
  await NotificationService.init();

  // Load persisted settings
  final storedLocale = await UserState.getLocale() ?? 'en';
  final storedName   = await UserState.getUserName() ?? '';
  final storedLang   = await UserState.getLanguagePreference() ?? 'English';
  final storedLevel  = await UserState.getUserLevel();

  runApp(
    ProviderScope(
      overrides: [
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

  /// Call this to change locale at runtime
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
    _setupRouter();
    _debugInit();
  }

  void _setupRouter() {
    _router = GoRouter(
      initialLocation: '/splash',
      routes: [
        GoRoute(
          path: '/splash',
          builder: (_, __) => SplashPage(
            onInitializationComplete: () => _router.push('/welcome'),
          ),
        ),
        GoRoute(
          path: '/welcome',
          builder: (_, __) => WelcomePage(
            onUserInfoSubmitted: (name, lang) async {
              // Persist name & language
              await UserState.setUserName(name);
              await UserState.setLanguagePreference(lang);
              ref.read(userNameProvider.notifier).state     = name;
              ref.read(languagePrefProvider.notifier).state = lang;
              _router.go('/register');
            },
          ),
        ),
        GoRoute(
          path: '/register',
          builder: (_, __) => const RegistrationPage(),
        ),
        GoRoute(
          path: '/profiling_chat_page',
          builder: (_, __) => const ProfilingChatPage(),
        ),
        GoRoute(
          path: '/skill_check_page',
          builder: (_, __) => const SkillCheckPage(),
        ),
        GoRoute(
          path: '/smartRecommendation',
          pageBuilder: (_, state) {
            final data = state.extra as Map<String, dynamic>?;
            return CustomTransitionPage(
              transitionDuration: const Duration(milliseconds: 400),
              transitionsBuilder: (_, animation, __, child) =>
                  FadeTransition(opacity: animation, child: child),
              child: data != null
                  ? SmartCourseRecommendationPage(
                      userName: data['userName'] as String,
                      languagePreference: data['languagePreference'] as String,
                      gender: data['gender'] as String,
                      age: data['age'] as String,
                      userLevel: data['userLevel'] as String,
                      recommendedCourses: List<String>.from(data['recommendedCourses'] as List),
                    )
                  : const Scaffold(body: Center(child: Text("❌ No data provided"))),
            );
          },
        ),

        // ... other routes unchanged ...
        GoRoute(path: '/chat', builder: (_, __) => IceBreakingChatPage(
          userName: ref.watch(userNameProvider),
          languagePreference: ref.watch(languagePrefProvider),
        )),
        GoRoute(path: '/menu', builder: (_, __) => const MenuPage()),
        GoRoute(path: '/coursesDashboard', builder: (_, __) => const CoursesDashboardPage()),
        GoRoute(
          path: '/courseDetail',
          pageBuilder: (_, state) {
            final course = state.extra as Map<String, dynamic>?;
            return CustomTransitionPage(
              transitionDuration: const Duration(milliseconds: 300),
              transitionsBuilder: (_, animation, __, child) =>
                  FadeTransition(opacity: animation, child: child),
              child: course != null
                  ? CourseDetailPage(course: course)
                  : const Scaffold(body: Center(child: Text("❌ Invalid course data."))),
            );
          },
        ),
        GoRoute(
          path: '/lessonPage',
          pageBuilder: (_, state) {
            final course = state.extra as Map<String, dynamic>?;
            return CustomTransitionPage(
              transitionDuration: const Duration(milliseconds: 300),
              transitionsBuilder: (_, animation, __, child) =>
                  FadeTransition(opacity: animation, child: child),
              child: course != null
                  ? LessonPage(
                      courseTitle: course['title'] as String,
                      courseIcon : course['icon']  as String,
                      courseColor: course['color'] as int,
                      lessons    : List<Map<String, String>>.from(course['lessons'] as List),
                    )
                  : const Scaffold(body: Center(child: Text("❌ Invalid lesson data."))),
            );
          },
        ),
        GoRoute(
          path: '/lessonComplete',
          pageBuilder: (_, state) {
            final data = state.extra as Map<String, dynamic>?;
            return CustomTransitionPage(
              transitionDuration: const Duration(milliseconds: 300),
              transitionsBuilder: (_, animation, __, child) =>
                  FadeTransition(opacity: animation, child: child),
              child: data != null
                  ? LessonCompletePage(
                      lessonId   : data['lessonId']    as String,
                      lessonTitle: data['lessonTitle'] as String,
                      earnedXP   : data['earnedXP']    as int,
                      badgeId    : data['badgeId']     as String?,
                    )
                  : const Scaffold(body: Center(child: Text("❌ Lesson data missing."))),
            );
          },
        ),
        GoRoute(path: '/achievements', builder: (_, __) => const AchievementsPage()),
        GoRoute(
          path: '/badgeDetail',
          pageBuilder: (_, state) {
            final badge = state.extra as Map<String, dynamic>?;
            return CustomTransitionPage(
              transitionDuration: const Duration(milliseconds: 300),
              transitionsBuilder: (_, animation, __, child) =>
                  FadeTransition(opacity: animation, child: child),
              child: badge != null
                  ? BadgeDetailPage(
                      title    : badge['title']     as String,
                      imagePath: badge['image']     as String,
                      unlocked : badge['unlocked']  as bool,
                      tag      : badge['tag']       as String,
                    )
                  : const Scaffold(body: Center(child: Text("❌ Badge data missing."))),
            );
          },
        ),
        GoRoute(path: '/userDashboard', builder: (_, __) => const UserDashboardPage()),
        GoRoute(path: '/leaderboard',     builder: (_, __) => const LeaderboardPage()),
        GoRoute(path: '/community',       builder: (_, __) => const CommunityPage()),
        GoRoute(
          path: '/friendDetail',
          pageBuilder: (_, state) {
            final data = state.extra as Map<String, dynamic>?;
            return CustomTransitionPage(
              transitionDuration: const Duration(milliseconds: 300),
              transitionsBuilder: (_, animation, __, child) =>
                  FadeTransition(opacity: animation, child: child),
              child: data != null
                  ? FriendDetailPage(
                      friendName : data['friendName']  as String,
                      avatarEmoji: data['avatarEmoji'] as String,
                      xp         : data['xp']          as int,
                      badges     : List<Map<String, dynamic>>.from(data['badges'] as List),
                    )
                  : const Scaffold(body: Center(child: Text("❌ Friend data missing."))),
            );
          },
        ),
        GoRoute(path: '/analytics', builder: (_, __) => const AnalyticsPage()),
      ],
    );
  }

  void _debugInit() {
    Future.microtask(() {
      debugPrint('🚀 FluentEdge Initialized with:');
      debugPrint('Locale: ${ref.read(localeProvider)}');
      debugPrint('User:   ${ref.read(userNameProvider)}');
      debugPrint('Lang:   ${ref.read(languagePrefProvider)}');
      debugPrint('Level:  ${ref.read(userLevelProvider)}');
    });
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
