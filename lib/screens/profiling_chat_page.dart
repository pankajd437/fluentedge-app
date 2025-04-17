import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fluentedge_app/constants.dart';
import 'package:fluentedge_app/widgets/animated_mentor_widget.dart';

class ProfilingChatPage extends ConsumerStatefulWidget {
  const ProfilingChatPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfilingChatPage> createState() => _ProfilingChatPageState();
}

class _ProfilingChatPageState extends ConsumerState<ProfilingChatPage> {
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _chat = [];

  int _currentStep = 0;
  bool _showTip = false;

  final List<_ChatQuestion> _questions = [
    _ChatQuestion(
      question: "How confident are you in speaking English?",
      key: "confidence",
      options: ["Beginner", "Intermediate", "Advanced"],
      mentorExpression: "mentor_curious_upper.png",
    ),
    _ChatQuestion(
      question: "How often do you want to practice?",
      key: "frequency",
      options: ["Every day", "2–3 times/week", "Once a week"],
      mentorExpression: "mentor_thinking_upper.png",
    ),
    _ChatQuestion(
      question: "What topics interest you most?",
      key: "interest",
      options: ["Movies", "Travel", "Family", "Work", "Culture"],
      mentorExpression: "mentor_tip_upper.png",
    ),
    _ChatQuestion(
      question: "What's your biggest challenge?",
      key: "challenge",
      options: ["Pronunciation", "Vocabulary", "Confidence", "Grammar"],
      mentorExpression: "mentor_sad_upper.png",
    ),
  ];

  final Map<String, String> _responses = {};

  @override
  void initState() {
    super.initState();
    _addMentorQuestion();
    _startTipTimer();
  }

  void _startTipTimer() {
    Future.delayed(const Duration(seconds: 6), () {
      if (mounted && _responses.length == _currentStep) {
        setState(() => _showTip = true);
      }
    });
  }

  void _addMentorQuestion() {
    if (_currentStep < _questions.length) {
      _chat.add({
        'type': 'mentor',
        'text': _questions[_currentStep].question,
        'expression': _questions[_currentStep].mentorExpression,
      });
    }
    _scrollToBottom();
  }

  void _onOptionSelected(String option) {
    final currentKey = _questions[_currentStep].key;
    _responses[currentKey] = option;

    _chat.add({'type': 'user', 'text': option});
    setState(() {
      _showTip = false;
      _currentStep++;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (_currentStep < _questions.length) {
        _addMentorQuestion();
        _startTipTimer();
      } else {
        context.go('/skill_check_page');
      }
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 150,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentExpression = _currentStep < _questions.length
        ? _questions[_currentStep].mentorExpression
        : 'mentor_wave_smile_full.png';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Let's Personalize Your Journey"),
        backgroundColor: kPrimaryBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: kBackgroundSoftBlue,
      body: Column(
        children: [
          const SizedBox(height: 10),
          AnimatedMentorWidget(expressionName: currentExpression),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _chat.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final entry = _chat[index];
                return Align(
                  alignment: entry['type'] == 'mentor'
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: entry['type'] == 'mentor'
                          ? Colors.white
                          : Colors.blue[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      entry['text'],
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_currentStep < _questions.length)
            Column(
              children: [
                if (_showTip)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      "💡 Not sure? Just pick what feels most like you!",
                      style: TextStyle(color: Colors.blueGrey.shade700),
                    ),
                  ),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: _questions[_currentStep]
                      .options
                      .map((option) => ElevatedButton(
                            onPressed: () => _onOptionSelected(option),
                            child: Text(option),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: kPrimaryBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(color: kPrimaryBlue),
                              ),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 16),
              ],
            )
        ],
      ),
    );
  }
}

class _ChatQuestion {
  final String question;
  final String key;
  final List<String> options;
  final String mentorExpression;

  const _ChatQuestion({
    required this.question,
    required this.key,
    required this.options,
    required this.mentorExpression,
  });
}
