import 'package:flutter/material.dart';
import 'screens/welcome_page.dart'; // Corrected Import Path

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures Flutter is fully initialized
  runApp(const FluentEdgeApp());
}

class FluentEdgeApp extends StatelessWidget {
  const FluentEdgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FluentEdge - Your AI English Mentor',
      debugShowCheckedModeBanner: false, // Removes debug banner for a clean UI
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins', // Default app font
        scaffoldBackgroundColor: Colors.white, // Ensures a clean background
        visualDensity: VisualDensity.adaptivePlatformDensity, // Optimizes layout for devices
      ),
      home: const WelcomePage(), // First screen the user sees
    );
  }
}
