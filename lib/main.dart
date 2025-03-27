import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Screens
import 'screens/welcome_page.dart';
import 'screens/ice_breaking_chat.dart';
import 'screens/questionnaire_page.dart';
import 'screens/courses_dashboard.dart'; // ✅ Existing
import 'screens/courses_list.dart'; // ✅ NEW Import

// Localization
import 'localization/app_localizations.dart';

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
        colorScheme: ColorScheme.light(
          primary: Colors.blue.shade800,
          secondary: Colors.amber,
          surface: Colors.grey[50]!,
          background: Colors.white,
        ),
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(fontSize: 16.0),
          bodyMedium: TextStyle(fontSize: 14.0),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue.shade800,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: Colors.blue.shade600,
          secondary: Colors.amber,
          surface: Colors.grey[900]!,
          background: Colors.grey[850]!,
        ),
        scaffoldBackgroundColor: Colors.grey[900],
      ),
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => Builder(
              builder: (context) => WelcomePage(
                onUserInfoSubmitted: (name, langPref) {
                  _setUserInfo(name, langPref);
                  Navigator.pushNamed(context, '/questionnaire');
                },
              ),
            ),
        '/questionnaire': (context) => QuestionnairePage(
              key: const ValueKey('questionnaire_page'),
              userName: _userName,
              languagePreference: _languagePreference,
            ),
        '/chat': (context) => IceBreakingChatPage(
              key: const ValueKey('chat_page'),
              userName: _userName,
              languagePreference: _languagePreference,
            ),
        '/coursesDashboard': (context) => const CoursesDashboardPage(), // ✅ Existing
        '/coursesList': (context) => CoursesListPage(), // ✅ New Route
      },
    );
  }
}
