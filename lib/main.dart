import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Screens
import 'package:fluentedge_app/screens/welcome_page.dart';
import 'package:fluentedge_app/screens/ice_breaking_chat.dart';
import 'package:fluentedge_app/screens/questionnaire_page.dart';
import 'package:fluentedge_app/screens/courses_dashboard.dart';
import 'package:fluentedge_app/screens/course_detail_page.dart';
import 'package:fluentedge_app/screens/lesson_page.dart'; // ✅ Added

// Localization
import 'package:fluentedge_app/localization/app_localizations.dart';

// Theme Constants
import 'package:fluentedge_app/constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: FluentEdgeApp()));
}

class FluentEdgeApp extends StatefulWidget {
  const FluentEdgeApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    final state = context.findAncestorStateOfType<_FluentEdgeAppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<FluentEdgeApp> createState() => _FluentEdgeAppState();
}

class _FluentEdgeAppState extends State<FluentEdgeApp> {
  Locale _locale = const Locale('en');
  String _userName = '';
  String _languagePreference = 'English';
  String _gender = '';
  int _age = 0;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  void _setUserInfo(String name, String langPref) {
    setState(() {
      _userName = name;
      _languagePreference = langPref;
    });
  }

  void _updateGenderAndAge(String gender, int age) {
    setState(() {
      _gender = gender;
      _age = age;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FluentEdge',
      debugShowCheckedModeBanner: false,
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
      ],
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
        appBarTheme: const AppBarTheme(
          backgroundColor: kPrimaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
      darkTheme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.grey[900],
        colorScheme: const ColorScheme.dark(
          primary: Colors.blue,
          secondary: kAccentGreen,
          surface: Colors.grey,
          background: Colors.grey,
        ),
      ),
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => WelcomePage(
              onUserInfoSubmitted: (name, langPref) {
                _setUserInfo(name, langPref);
                Navigator.pushNamed(context, '/questionnaire');
              },
            ),
        '/questionnaire': (context) => QuestionnairePage(
              key: const ValueKey('questionnaire_page'),
              userName: _userName,
              languagePreference: _languagePreference,
              onGenderAndAgeSubmitted: (gender, age) {
                _updateGenderAndAge(gender, age);
              },
            ),
        '/chat': (context) => IceBreakingChatPage(
              key: const ValueKey('chat_page'),
              userName: _userName,
              languagePreference: _languagePreference,
            ),
        '/coursesDashboard': (context) => const CoursesDashboardPage(),

        // ✅ Course Detail Page
        '/courseDetail': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          if (args is Map<String, dynamic>) {
            return CourseDetailPage(course: args);
          } else {
            return const Scaffold(
              body: Center(child: Text("❌ Invalid course data.")),
            );
          }
        },

        // ✅ Lesson Page
        '/lessonPage': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          if (args is Map<String, dynamic>) {
            return LessonPage(course: args);
          } else {
            return const Scaffold(
              body: Center(child: Text("❌ Invalid lesson data.")),
            );
          }
        },
      },
    );
  }
}
