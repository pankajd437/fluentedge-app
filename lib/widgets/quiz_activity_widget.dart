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
  final String? correctSound;
  final String? wrongSound;

  // NEW optional fields:
  final List<String>? hints;            // If user can request a hint
  final bool allowRetry;               // If user can try answering again after failing
  final String? encouragementOnFail;   // Show if user picks the wrong answer

  const QuizActivityWidget({
    Key? key,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.onCompleted,
    this.onAnswerSelected,
    this.correctSound,
    this.wrongSound,
    // New fields with default values for safety
    this.hints,
    this.allowRetry = false,
    this.encouragementOnFail,
  }) : super(key: key);

  @override
  State<QuizActivityWidget> createState() => _QuizActivityWidgetState();
}

class _QuizActivityWidgetState extends State<QuizActivityWidget> {
  final AudioPlayer _player = AudioPlayer();

  bool _answered = false;
  int? _selectedIndex;

  // For hints
  bool _hintVisible = false;

  // If the user got it wrong and is allowed to retry
  bool _failedAttempt = false;

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _playSound(bool isCorrect) async {
    final path = isCorrect
        ? widget.correctSound ?? 'assets/sounds/correct.mp3'
        : widget.wrongSound ?? 'assets/sounds/incorrect.mp3';
    try {
      await _player.stop();
      await _player.play(AssetSource(path.replaceFirst('assets/', '')));
    } catch (e) {
      debugPrint("❌ Sound error: $e");
    }
  }

  void _showFeedbackAnimation(bool isCorrect) {
    final overlay = Overlay.of(context);
    if (overlay == null) return;

    final overlayEntry = OverlayEntry(
      builder: (context) => Center(
        child: SizedBox(
          width: 180,
          height: 180,
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
    Future.delayed(const Duration(seconds: 2), () => overlayEntry.remove());
  }

  void _handleAnswer(int index) async {
    if (_answered && !widget.allowRetry) return; // can't choose again if answered, unless allowRetry
    if (_answered && widget.allowRetry && !_failedAttempt) return; // if user answered correct once, no need to re-answer

    setState(() {
      _selectedIndex = index;
      _answered = true;
    });

    final isCorrect = index == widget.correctIndex;

    await _playSound(isCorrect);
    _showFeedbackAnimation(isCorrect);
    widget.onAnswerSelected?.call(isCorrect);

    if (!isCorrect) {
      // Wrong answer
      setState(() => _failedAttempt = true);
    } else {
      // Correct => quiz completed
      // If you want to auto-jump after correct, uncomment:
      // Future.delayed(const Duration(seconds: 2), widget.onCompleted);
    }
    // If user is correct or allowRetry is false, user typically presses next in LessonActivityPage
  }

  void _retryQuiz() {
    // Let user select again
    setState(() {
      _answered = false;
      _selectedIndex = null;
      _hintVisible = false;
      _failedAttempt = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final gradients = [
      [Colors.deepPurple, Colors.purpleAccent],
      [Colors.blue, Colors.lightBlueAccent],
      [Colors.green, Colors.lightGreen],
      [Colors.orange, Colors.deepOrange],
      [Colors.teal, Colors.cyan],
    ];

    final bool isCorrect = (_selectedIndex != null && _selectedIndex == widget.correctIndex);
    final bool showRetryButton = widget.allowRetry && _failedAttempt && !_answeredCorrectlyYet();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "🧠 Quiz Time",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: kPrimaryBlue,
          ),
        ),
        const SizedBox(height: 16),

        // The question
        Text(
          widget.question,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),

        // HINT Button if we have hints and haven't answered or still allowed to retry
        if ((widget.hints != null && widget.hints!.isNotEmpty) && !_answeredCorrectlyYet())
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () => setState(() => _hintVisible = true),
                icon: const Icon(Icons.lightbulb_outline),
                label: const Text("Hint"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
              ),
              if (_hintVisible && !_answeredCorrectlyYet()) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Text(
                      // For simplicity, show the first hint or combine all hints
                      widget.hints!.join("\n• "),
                      style: const TextStyle(color: Colors.black87, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ],
          ),

        const SizedBox(height: 12),

        // The multiple-choice options
        ...widget.options.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;
          final gradient = gradients[index % gradients.length];
          final isSelected = index == _selectedIndex;
          final isOptionCorrect = index == widget.correctIndex;

          Color? backgroundColor;
          if (_answered) {
            if (isSelected && isOptionCorrect) {
              backgroundColor = Colors.green.shade600;
            } else if (isSelected && !isOptionCorrect) {
              backgroundColor = Colors.red.shade400;
            }
          }

          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: !_answered ? LinearGradient(colors: gradient) : null,
              color: _answered ? backgroundColor : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: !_answered || (widget.allowRetry && _failedAttempt)
                    ? () => _handleAnswer(index)
                    : null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Icon(
                        _answered && isSelected
                            ? (isOptionCorrect ? Icons.check_circle : Icons.cancel)
                            : Icons.circle_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          option,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
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

        // If user got it wrong and there's an encouragementOnFail, show it
        if (_failedAttempt && !isCorrect && widget.encouragementOnFail != null && _answered)
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.yellow.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.yellow.shade100),
            ),
            child: Text(
              widget.encouragementOnFail!,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),

        // Show retry button if user is allowed to retry and has answered incorrectly
        if (showRetryButton)
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: ElevatedButton.icon(
              onPressed: _retryQuiz,
              icon: const Icon(Icons.refresh),
              label: const Text("Try Again"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),
          ),
      ],
    );
  }

  bool _answeredCorrectlyYet() {
    return _answered && _selectedIndex == widget.correctIndex;
  }
}
