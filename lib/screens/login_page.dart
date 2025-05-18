import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';

import 'package:fluentedge_app/constants.dart';
import 'package:fluentedge_app/widgets/animated_mentor_widget.dart';
import 'package:fluentedge_app/main.dart'; // for route references
import 'package:fluentedge_app/data/user_state.dart'; // ensure we can call UserState

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  bool _isLoading = false;

  Future<void> _attemptLogin() async {
    final email = _emailController.text.trim().toLowerCase();

    if (email.isEmpty || !email.contains("@") || !email.contains(".")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid email address.")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Use the correct endpoint /api/v1/login
      final response = await http.post(
        Uri.parse('${ApiConfig.local}/api/v1/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      if (response.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No user found with this email.")),
        );
        return;
      }

      final loginData = jsonDecode(response.body);
      final String userId = loginData["user_id"];
      final String name = loginData["name"];
      final String language = loginData["language"];
      final String learningGoal = loginData["learning_goal"];

      // Next, fetch recommended courses from /api/v1/user/{user_id}/recommendations
      final recRes = await http.get(
        Uri.parse('${ApiConfig.local}/api/v1/user/$userId/recommendations'),
      );

      if (recRes.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not fetch course recommendations.")),
        );
        return;
      }

      final recData = jsonDecode(recRes.body);
      final String userLevel = recData["user_level"];
      final List<String> recommendedCourses =
          List<String>.from(recData["recommended_courses"]);

      // Store user data in Hive
      final userBox = await Hive.openBox(kHiveBoxSettings);
      await userBox.put('user_id', userId);
      await userBox.put(kHiveKeyUserName, name);
      await userBox.put(kHiveKeyEmail, email);
      await userBox.put(kHiveKeyLanguagePreference, language);
      await userBox.put(kHiveKeyLearningGoal, learningGoal);
      await userBox.put(kHiveKeyUserLevel, userLevel);
      await userBox.put(kHiveKeyRecommendedCourses, recommendedCourses);

      // 🔥 IMPORTANT: Also set in UserState so other screens see the correct name:
      await UserState.setUserName(name);

      // Update Riverpod states for immediate use
      ref.read(userNameProvider.notifier).state = name;
      ref.read(languagePrefProvider.notifier).state = language;
      ref.read(userLevelProvider.notifier).state = userLevel;

      // Small user feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("👋 Welcome back, $name!")),
      );

      // brief delay, then navigate
      Future.delayed(const Duration(milliseconds: 700), () {
        context.go(routeUserDashboard);
      });
    } catch (e) {
      debugPrint("❌ Login error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login failed. Please try again.")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),

            // 🎯 Mentor animation
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 700),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(scale: animation, child: child),
                );
              },
              child: const AnimatedMentorWidget(
                key: ValueKey("mentor_big"),
                size: 320,
                expressionName: 'mentor_wave_smile_full.png',
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              "Welcome Back!",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                "Login with your registered email to access your dashboard and resume your journey.",
                style: TextStyle(fontSize: 14, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),

            // 📩 Email field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: TextField(
                controller: _emailController,
                focusNode: _emailFocus,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email Address",
                  prefixIcon: const Icon(Icons.email),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 🔘 Continue button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _attemptLogin,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: kPrimaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "Continue",
                            key: ValueKey("continue"),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
