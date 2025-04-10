import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluentedge_app/constants.dart';
import 'package:fluentedge_app/widgets/animated_mentor_widget.dart';
import 'package:fluentedge_app/widgets/quiz_activity_widget.dart';

class LessonActivityPage extends StatefulWidget {
  final Map<String, dynamic> lesson;

  const LessonActivityPage({Key? key, required this.lesson}) : super(key: key);

  @override
  State<LessonActivityPage> createState() => _LessonActivityPageState();
}

class _LessonActivityPageState extends State<LessonActivityPage> {
  String _expressionName = 'Processing';
  String _speechText = "Let's get started!";
  Timer? _resetTimer;
  bool _lastAnswerCorrect = false;

  void _updateMentorFeedback(String newExpression, String speech, {bool reset = true}) {
    setState(() {
      _expressionName = newExpression;
      _speechText = speech;
    });

    _resetTimer?.cancel();

    if (reset && newExpression != 'Confused') {
      _resetTimer = Timer(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _expressionName = 'Processing';
            _speechText = "Let's keep going!";
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String lessonTitle = widget.lesson['title'] ?? 'Lesson Title';

    return Scaffold(
      backgroundColor: kBackgroundSoftBlue,
      appBar: AppBar(
        backgroundColor: kPrimaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          lessonTitle,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ✅ AI Mentor Section
            Column(
              children: [
                Center(child: AnimatedMentorWidget(size: 140, expressionName: _expressionName)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
                    ],
                  ),
                  child: Text(
                    _speechText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 🎯 Quiz Widget
            QuizActivityWidget(
              question: "Which word means the opposite of 'cold'?",
              options: ['Hot', 'Warm', 'Freeze', 'Cool'],
              correctIndex: 0,
              onCompleted: () {
                if (_lastAnswerCorrect) {
                  _updateMentorFeedback('Celebrating', "You did great!");
                }
                Future.delayed(const Duration(seconds: 1), () {
                  GoRouter.of(context).push(
                    '/lessonComplete',
                    extra: {
                      'lessonTitle': lessonTitle,
                      'isCorrect': _lastAnswerCorrect,
                    },
                  );
                });
              },
              onAnswerSelected: (isCorrect) {
                _lastAnswerCorrect = isCorrect;
                if (isCorrect) {
                  _updateMentorFeedback('Celebrating', "That's right!");
                } else {
                  _updateMentorFeedback('Confused', "Oops! Not quite.", reset: false);
                }
              },
            ),

            const Spacer(),

            // Manual completion button (optional fallback)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  GoRouter.of(context).push(
                    '/lessonComplete',
                    extra: {
                      'lessonTitle': lessonTitle,
                      'isCorrect': _lastAnswerCorrect,
                    },
                  );
                },
                icon: const Icon(Icons.check_circle_outline),
                label: const Text("Complete Lesson"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAccentGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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
