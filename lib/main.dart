import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Screens
import 'screens/welcome_page.dart';
import 'screens/ice_breaking_chat.dart';
import 'screens/questionnaire_page.dart';
import 'screens/courses_dashboard.dart';
import 'screens/courses_list.dart';

// Localization
import 'localization/app_localizations.dart';

// Theme Constants
import 'constants.dart';

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
          secondary: kAccentBlue,
          background: Colors.white,
          surface: Colors.white,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
          bodyLarge: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
          bodyMedium: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: kPrimaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      darkTheme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.dark(
          primary: Colors.blue,
          secondary: kAccentBlue,
          surface: Colors.grey,
          background: Colors.grey,
        ),
        scaffoldBackgroundColor: Colors.grey[900],
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
        '/coursesList': (context) => CoursesListPage(),
      },
    );
  }
}
