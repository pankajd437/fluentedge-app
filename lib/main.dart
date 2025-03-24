import 'package:flutter/material.dart';
import 'screens/welcome_page.dart';
import 'screens/chat_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FluentEdgeApp());
}

class FluentEdgeApp extends StatelessWidget {
  const FluentEdgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FluentEdge - Your AI English Mentor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Poppins', fontSize: 16),
          bodyMedium: TextStyle(fontFamily: 'Poppins', fontSize: 14),
        ),
      ),
      home: const WelcomePage(),
      routes: {
        '/chat': (context) => const ChatPage(),
      },
    );
  }
}