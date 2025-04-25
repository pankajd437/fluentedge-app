import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:go_router/go_router.dart';

import 'package:fluentedge_app/localization/app_localizations.dart';
import 'package:fluentedge_app/main.dart';
import 'package:fluentedge_app/constants.dart';
import 'package:fluentedge_app/widgets/animated_mentor_widget.dart';

class WelcomePage extends ConsumerStatefulWidget {
  final Function(String, String) onUserInfoSubmitted;

  const WelcomePage({
    super.key,
    required this.onUserInfoSubmitted,
  });

  @override
  ConsumerState<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends ConsumerState<WelcomePage> {
  String selectedLanguage = "English";
  bool showWelcomeText = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1200), () {
      setState(() => showWelcomeText = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isHindi = selectedLanguage == "हिंदी";

    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FB),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),

            // 🚀 FluentEdge Logo
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Image.asset(
                'assets/images/FluentEdge Logo.png',
                width: 120,
                height: 120,
              ),
            ),

            // Mentor image + animated greeting
            const AnimatedMentorWidget(
              size: 200,
              expressionName: 'mentor_wave_smile_full.png',
            ),

            const SizedBox(height: 20),

            // 🌐 Language selection
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: DropdownButtonFormField<String>(
                value: selectedLanguage,
                decoration: const InputDecoration(
                  labelText: "Select Language / भाषा चुनें",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) async {
                  if (value != null) {
                    setState(() {
                      selectedLanguage = value;
                      showWelcomeText = true;
                    });
                    FluentEdgeApp.updateLocale(
                      ref,
                      value == "हिंदी" ? const Locale('hi') : const Locale('en'),
                    );
                    final box = await Hive.openBox('settings');
                    await box.put('language', selectedLanguage);
                  }
                },
                items: [
                  DropdownMenuItem(value: "English", child: Text(localizations.englishLanguageName)),
                  DropdownMenuItem(value: "हिंदी", child: Text(localizations.hindiLanguageName)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🧠 Welcome message after language selected
            if (showWelcomeText)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 600),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(scale: animation, child: child),
                        );
                      },
                      child: Text(
                        isHindi
                            ? localizations.welcomeMessageHindi
                            : localizations.welcomeMessage,
                        key: ValueKey<bool>(isHindi),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0D47A1),
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 600),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(scale: animation, child: child),
                        );
                      },
                      child: Text(
                        isHindi
                            ? "AI Mentor के साथ English बोलना शुरू करें — आपकी ज़रूरतों के अनुसार!"
                            : localizations.welcomeSubtitle,
                        key: ValueKey<String>(selectedLanguage),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const Spacer(),

            // 🎯 Three main CTA buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      GoRouter.of(context).go(routeRegistration);
                    },
                    icon: const Icon(Icons.person_add),
                    label: const Text("Register"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryBlue,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () {
                      GoRouter.of(context).go(routeLogin);
                    },
                    icon: const Icon(Icons.login),
                    label: const Text("Login"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kPrimaryBlue,
                      side: const BorderSide(color: kPrimaryBlue),
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      ref.read(userNameProvider.notifier).state = "Guest";
                      ref.read(languagePrefProvider.notifier).state = selectedLanguage;
                      GoRouter.of(context).go(routeCoursesDashboard);
                    },
                    child: const Text(
                      "Explore as Guest",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
