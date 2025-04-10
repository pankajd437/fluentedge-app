import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:fluentedge_app/constants.dart';

class QuizActivityWidget extends StatefulWidget {
  final String question;
  final List<String> options;
  final int correctIndex;
  final VoidCallback onCompleted;
  final ValueChanged<bool>? onAnswerSelected;

  const QuizActivityWidget({
    super.key,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.onCompleted,
    this.onAnswerSelected,
  });

  @override
  State<QuizActivityWidget> createState() => _QuizActivityWidgetState();
}

class _QuizActivityWidgetState extends State<QuizActivityWidget> {
  final AudioPlayer _player = AudioPlayer();
  bool _answered = false;
  int? _selectedIndex;

  void _handleAnswer(int index) async {
    if (_answered) return;

    setState(() {
      _selectedIndex = index;
      _answered = true;
    });

    final isCorrect = index == widget.correctIndex;

    await _playSound(isCorrect);
    _showFeedbackAnimation(isCorrect);

    widget.onAnswerSelected?.call(isCorrect);

    // ✅ Only move to next screen if correct
    if (isCorrect) {
      Future.delayed(const Duration(seconds: 2), widget.onCompleted);
    }
  }

  Future<void> _playSound(bool isCorrect) async {
    final path = isCorrect ? 'assets/sounds/correct.mp3' : 'assets/sounds/incorrect.mp3';
    try {
      await _player.stop();
      await _player.play(AssetSource(path.replaceFirst('assets/', '')));
    } catch (e) {
      debugPrint("❌ Error playing sound: $e");
    }
  }

  void _showFeedbackAnimation(bool isCorrect) {
    final overlay = Overlay.of(context);
    if (overlay == null) return;

    final overlayEntry = OverlayEntry(
      builder: (context) => Center(
        child: SizedBox(
          width: 220,
          height: 220,
          child: Lottie.asset(
            isCorrect
                ? 'assets/animations/activity_correct.json'
                : 'assets/animations/activity_wrong.json',
            repeat: false,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2), overlayEntry.remove);
  }

  @override
  Widget build(BuildContext context) {
    final List<List<Color>> optionGradients = [
      [Colors.deepPurple, Colors.purpleAccent],
      [Colors.blue, Colors.lightBlue],
      [Colors.green, Colors.lightGreen],
      [Colors.orange, Colors.deepOrange],
      [Colors.teal, Colors.cyan],
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "🧠 Activity",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: kPrimaryIconBlue,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          widget.question,
          style: const TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 24),
        ...widget.options.asMap().entries.map((entry) {
          final index = entry.key;
          final value = entry.value;
          final gradient = optionGradients[index % optionGradients.length];

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => _handleAnswer(index),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Icon(
                        _selectedIndex == index
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          value,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
