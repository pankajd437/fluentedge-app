import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedMentorWidget extends StatefulWidget {
  final double size;
  final String expressionName;
  final bool loop;
  final Duration idleSwitchDuration;

  const AnimatedMentorWidget({
    Key? key,
    required this.expressionName,
    this.size = 200,
    this.loop = false,
    this.idleSwitchDuration = const Duration(seconds: 4),
  }) : super(key: key);

  @override
  State<AnimatedMentorWidget> createState() => _AnimatedMentorWidgetState();
}

class _AnimatedMentorWidgetState extends State<AnimatedMentorWidget> {
  final List<String> expressions = [
    'Alert',
    'Angry',
    'Apologetic',
    'Awkward',
    'Celebrating',
    'Confident',
    'Confused',
    'Curious',
    'Encouraging',
    'Explaining',
    'Greeting',
    'Happy',
    'Idea',
    'Processing',
    'Sleepy',
    'Surprised',
  ];

  String _currentExpression = 'Greeting';
  late String _currentPath;
  Timer? _switchTimer;

  @override
  void initState() {
    super.initState();
    // Set initial expression + path from the widget
    _currentExpression = widget.expressionName.isNotEmpty
        ? widget.expressionName
        : 'Greeting'; // fallback if expressionName is empty
    _currentPath = _getPngPath(_currentExpression);

    // If loop is true and expressionName is empty, randomly switch expressions
    if (widget.loop && widget.expressionName.isEmpty) {
      _startLoop();
    }
  }

  /// **NEW**: If parent changes `expressionName`, we update the image to match.
  @override
  void didUpdateWidget(covariant AnimatedMentorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Only update if expressionName actually changed
    if (oldWidget.expressionName != widget.expressionName) {
      setState(() {
        _currentExpression = widget.expressionName.isNotEmpty
            ? widget.expressionName
            : 'Greeting'; // fallback
        _currentPath = _getPngPath(_currentExpression);
      });
    }
  }

  /// Called periodically if we're in loop mode with an empty expressionName
  void _startLoop() {
    _switchTimer = Timer.periodic(widget.idleSwitchDuration, (_) {
      final random = expressions[Random().nextInt(expressions.length)];
      setState(() => _currentPath = _getPngPath(random));
    });
  }

  /// Build a PNG path from the expression name
  String _getPngPath(String expression) {
    final normalized = expression.toLowerCase().replaceAll(' ', '_');
    return 'assets/images/mentor_expressions/${_capitalize(normalized)} AI mentor.png';
  }

  /// Ensure first letter is uppercase
  String _capitalize(String text) {
    return text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);
  }

  @override
  void dispose() {
    _switchTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.95, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.size * 0.5),
            child: Image.asset(
              // We always use the newly updated path
              _getPngPath(_currentExpression),
              width: widget.size,
              height: widget.size,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) {
                debugPrint("❌ Mentor image not found for: $_currentExpression");
                return Container(
                  width: widget.size,
                  height: widget.size,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.shade100,
                  ),
                  child: const Icon(Icons.error_outline, size: 48, color: Colors.red),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
