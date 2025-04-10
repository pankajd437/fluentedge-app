import 'package:fluentedge_app/screens/analytics_page.dart'; // ✅ NEW
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:fluentedge_app/services/notification_service.dart'; // ✅ NEW

import 'package:fluentedge_app/constants.dart';
import 'package:fluentedge_app/data/user_state.dart';

// Screens
import 'package:fluentedge_app/screens/welcome_page.dart';
import 'package:fluentedge_app/screens/ice_breaking_chat.dart';
import 'package:fluentedge_app/screens/questionnaire_page.dart';
import 'package:fluentedge_app/screens/courses_dashboard.dart';
import 'package:fluentedge_app/screens/course_detail_page.dart';
import 'package:fluentedge_app/screens/lesson_page.dart';
import 'package:fluentedge_app/screens/lesson_complete_page.dart';
import 'package:fluentedge_app/screens/splash_page.dart';
import 'package:fluentedge_app/screens/smart_course_recommendation.dart';
import 'package:fluentedge_app/screens/achievements_page.dart';
import 'package:fluentedge_app/screens/badge_detail_page.dart';
import 'package:fluentedge_app/screens/user_dashboard_page.dart';
import 'package:fluentedge_app/screens/leaderboard_page.dart';
import 'package:fluentedge_app/screens/community_page.dart';
import 'package:fluentedge_app/screens/friend_detail_page.dart';

import 'package:fluentedge_app/localization/app_localizations.dart';

final localeProvider = StateProvider<Locale>((ref) => const Locale('en'));
final userNameProvider = StateProvider<String>((ref) => '');
final languagePrefProvider = StateProvider<String>((ref) => 'English');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await NotificationService.init(); // ✅ INIT LOCAL NOTIFICATION SERVICE

  final storedLocale = await UserState.getLocale() ?? 'en';
  final userName = await UserState.getUserName() ?? '';
  final langPref = await UserState.getLanguagePreference() ?? 'English';

  runApp(
    ProviderScope(
      overrides: [
        localeProvider.overrideWith((_) => Locale(storedLocale)),
        userNameProvider.overrideWith((_) => userName),
        languagePrefProvider.overrideWith((_) => langPref),
      ],
      child: FluentEdgeApp(initialLocale: Locale(storedLocale)),
    ),
  );
}

class FluentEdgeApp extends ConsumerStatefulWidget {
  final Locale initialLocale;
  const FluentEdgeApp({super.key, required this.initialLocale});

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
    _debugInitialization();
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
          pageBuilder: (_, __) => CustomTransitionPage(
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder: (context, animation, _, child) =>
                FadeTransition(opacity: animation, child: child),
            child: WelcomePage(
              onUserInfoSubmitted: (name, langPref) async {
                await UserState.setUserName(name);
                await UserState.setLanguagePreference(langPref);
                ref.read(userNameProvider.notifier).state = name;
                ref.read(languagePrefProvider.notifier).state = langPref;
                _router.go('/questionnaire');
              },
            ),
          ),
        ),
        GoRoute(path: '/questionnaire', builder: (_, __) => QuestionnairePage(
          key: const ValueKey('questionnaire_page'),
          userName: ref.watch(userNameProvider),
          languagePreference: ref.watch(languagePrefProvider),
          onCompleted: (gender, age, recommendedCourses) {
            _router.go('/smartRecommendation', extra: {
              'userName': ref.read(userNameProvider),
              'languagePreference': ref.read(languagePrefProvider),
              'gender': gender,
              'age': age,
              'recommendedCourses': recommendedCourses,
            });
          },
        )),
        GoRoute(path: '/smartRecommendation', pageBuilder: (_, state) {
          final data = state.extra as Map<String, dynamic>?;
          return CustomTransitionPage(
            transitionDuration: const Duration(milliseconds: 400),
            transitionsBuilder: (context, animation, _, child) =>
                FadeTransition(opacity: animation, child: child),
            child: data != null
                ? SmartCourseRecommendationPage(
                    userName: data['userName'],
                    languagePreference: data['languagePreference'],
                    gender: data['gender'],
                    age: data['age'],
                    recommendedCourses: List<String>.from(data['recommendedCourses']),
                  )
                : const Scaffold(body: Center(child: Text("❌ No recommendation data."))),
          );
        }),
        GoRoute(path: '/chat', builder: (_, __) => IceBreakingChatPage(
          key: const ValueKey('chat_page'),
          userName: ref.watch(userNameProvider),
          languagePreference: ref.watch(languagePrefProvider),
        )),
        GoRoute(path: '/coursesDashboard', builder: (_, __) => const CoursesDashboardPage()),
        GoRoute(path: '/courseDetail', pageBuilder: (_, state) {
          final course = state.extra as Map<String, dynamic>?;
          return CustomTransitionPage(
            transitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder: (context, animation, _, child) =>
                FadeTransition(opacity: animation, child: child),
            child: course != null ? CourseDetailPage(course: course) : const Scaffold(body: Center(child: Text("❌ Invalid course data."))),
          );
        }),
        GoRoute(path: '/lessonPage', pageBuilder: (_, state) {
          final course = state.extra as Map<String, dynamic>?;
          return CustomTransitionPage(
            transitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder: (context, animation, _, child) =>
                FadeTransition(opacity: animation, child: child),
            child: course != null ? LessonPage(course: course) : const Scaffold(body: Center(child: Text("❌ Invalid lesson data."))),
          );
        }),
        GoRoute(path: '/lessonComplete', pageBuilder: (_, state) {
          final data = state.extra as Map<String, dynamic>?;
          return CustomTransitionPage(
            transitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder: (context, animation, _, child) =>
                FadeTransition(opacity: animation, child: child),
            child: data != null ? LessonCompletePage(lessonTitle: data['lessonTitle'] ?? "Lesson") : const Scaffold(body: Center(child: Text("❌ Lesson title missing."))),
          );
        }),
        GoRoute(path: '/achievements', builder: (_, __) => const AchievementsPage()),
        GoRoute(path: '/badgeDetail', pageBuilder: (_, state) {
          final badge = state.extra as Map<String, dynamic>?;
          return CustomTransitionPage(
            transitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder: (context, animation, _, child) =>
                FadeTransition(opacity: animation, child: child),
            child: badge != null
                ? BadgeDetailPage(
                    title: badge['title'],
                    imagePath: badge['image'],
                    unlocked: badge['unlocked'],
                    tag: badge['tag'],
                  )
                : const Scaffold(body: Center(child: Text("❌ Badge data missing."))),
          );
        }),
        GoRoute(path: '/userDashboard', builder: (_, __) => const UserDashboardPage()),
        GoRoute(path: '/leaderboard', builder: (_, __) => const LeaderboardPage()),
        GoRoute(path: '/community', builder: (_, __) => const CommunityPage()),
        GoRoute(
          path: '/friendDetail',
          pageBuilder: (_, state) {
            final data = state.extra as Map<String, dynamic>?;
            return CustomTransitionPage(
              transitionDuration: const Duration(milliseconds: 300),
              transitionsBuilder: (context, animation, _, child) =>
                  FadeTransition(opacity: animation, child: child),
              child: FriendDetailPage(
                friendName: data?['friendName'] ?? 'Friend',
                avatarEmoji: data?['avatarEmoji'] ?? '🙂',
                xp: data?['xp'] ?? 0,
                badges: List<Map<String, dynamic>>.from(data?['badges'] ?? []),
              ),
            );
          },
        ),
        GoRoute(path: '/analytics', builder: (_, __) => const AnalyticsPage()),
      ],
    );
  }

  void _debugInitialization() {
    Future.microtask(() {
      debugPrint('🚀 FluentEdge Initialization Debug:');
      debugPrint('Locale: ${ref.read(localeProvider)}');
      debugPrint('UserName: ${ref.read(userNameProvider)}');
      debugPrint('LanguagePref: ${ref.read(languagePrefProvider)}');
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
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: const ColorScheme.light(
          primary: kPrimaryBlue,
          secondary: kAccentGreen,
          background: Colors.white,
          surface: Colors.white,
        ),
        textTheme: kAppTextTheme,
      ),
      darkTheme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: kDarkBackground,
        colorScheme: const ColorScheme.dark(
          primary: kDarkPrimaryBlue,
          secondary: kDarkAccentGreen,
          surface: kDarkCardBackground,
          background: kDarkBackground,
        ),
        textTheme: kAppTextTheme,
      ),
      routerConfig: _router,
    );
  }
}
