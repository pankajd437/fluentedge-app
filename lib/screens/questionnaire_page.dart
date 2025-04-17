// lib/screens/questionnaire_page.dart

import 'package:flutter/material.dart';
import 'package:fluentedge_app/screens/profiling_chat_page.dart';
import 'package:fluentedge_app/screens/skill_check_page.dart';

/// This page now simply kicks off the two‑step onboarding:
///  1️⃣ profiling_chat_page.dart  
///  2️⃣ skill_check_page.dart  
/// and then hands off gender, age, recommendations & userLevel.
class QuestionnairePage extends StatefulWidget {
  final String userName;
  final String languagePreference;
  final void Function(
    String gender,
    int age,
    List<String> recommendedCourses,
    String userLevel,
  ) onCompleted;

  const QuestionnairePage({
    Key? key,
    required this.userName,
    required this.languagePreference,
    required this.onCompleted,
  }) : super(key: key);

  @override
  State<QuestionnairePage> createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  late String _gender;
  late int _age;
  late List<String> _recommendedCourses;
  late String _userLevel;

  @override
  void initState() {
    super.initState();
    // Start immediately
    WidgetsBinding.instance.addPostFrameCallback((_) => _startProfiling());
  }

  void _startProfiling() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProfilingChatPage(
          userName: widget.userName,
          languagePreference: widget.languagePreference,
          onProfileComplete: (gender, age, recs, level) {
            _gender = gender;
            _age = age;
            _recommendedCourses = recs;
            _userLevel = level;
            _startSkillCheck();
          },
        ),
      ),
    );
  }

  void _startSkillCheck() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SkillCheckPage(
          userName: widget.userName,
          languagePreference: widget.languagePreference,
          onCheckComplete: () {
            // Once both steps are done, hand back to main.dart
            widget.onCompleted(
              _gender,
              _age,
              _recommendedCourses,
              _userLevel,
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // While routing to profiling → skill check → done, just show a spinner
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
