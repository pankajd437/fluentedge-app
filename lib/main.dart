import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/welcome_page.dart';
import 'screens/chat_page.dart';
import 'localization/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: FluentEdgeApp(),
    ),
  );
}

class FluentEdgeApp extends StatefulWidget {
  const FluentEdgeApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    _FluentEdgeAppState? state = context.findAncestorStateOfType<_FluentEdgeAppState>();
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

  void _setUserInfo(String userName, String languagePreference) {
    setState(() {
      _userName = userName;
      _languagePreference = languagePreference;
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
        Locale('en'), // English
        Locale('hi'), // Hindi
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
      home: WelcomePage(
        onUserInfoSubmitted: _setUserInfo,
      ),
      routes: {
        ChatPage.routeName: (context) => ChatPage(
              userName: _userName,
              languagePreference: _languagePreference,
            ),
      },
    );
  }
}