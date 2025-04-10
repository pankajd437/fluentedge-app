import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedMentorWidget extends StatefulWidget {
  final double size;
  final String? expressionName;

  const AnimatedMentorWidget({
    super.key,
    this.size = 200,
    this.expressionName,
  });

  @override
  State<AnimatedMentorWidget> createState() => _AnimatedMentorWidgetState();
}

class _AnimatedMentorWidgetState extends State<AnimatedMentorWidget> {
  final List<String> expressionPaths = [
    'assets/images/mentor_expressions/Alert AI mentor.png',
    'assets/images/mentor_expressions/Angry AI mentor.png',
    'assets/images/mentor_expressions/Apologetic AI mentor.png',
    'assets/images/mentor_expressions/Awkward AI mentor.png',
    'assets/images/mentor_expressions/Celebrating AI mentor.png',
    'assets/images/mentor_expressions/Confident AI mentor.png',
    'assets/images/mentor_expressions/Confused AI mentor.png',
    'assets/images/mentor_expressions/Curious AI mentor.png',
    'assets/images/mentor_expressions/Encouraging AI mentor.png',
    'assets/images/mentor_expressions/Explaining AI mentor.png',
    'assets/images/mentor_expressions/Greeting AI mentor.png',
    'assets/images/mentor_expressions/Happy AI mentor.png',
    'assets/images/mentor_expressions/Idea AI mentor.png',
    'assets/images/mentor_expressions/Processing AI mentor.png',
    'assets/images/mentor_expressions/Sleepy AI mentor.png',
    'assets/images/mentor_expressions/Surprised AI mentor.png',
  ];

  String? _overridePath;
  Timer? _revertTimer;

  void _triggerInteraction() {
    if (widget.expressionName != null) return;

    final random = Random();
    final randomPath = expressionPaths[random.nextInt(expressionPaths.length)];

    setState(() => _overridePath = randomPath);

    _revertTimer?.cancel();
    _revertTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _overridePath = null);
      }
    });
  }

  String _getCurrentExpressionPath() {
    if (widget.expressionName != null) {
      return expressionPaths.firstWhere(
        (path) => path.toLowerCase().contains(widget.expressionName!.toLowerCase()),
        orElse: () => expressionPaths[0],
      );
    }
    return _overridePath ?? 'assets/images/mentor_expressions/Greeting AI mentor.png';
  }

  @override
  void dispose() {
    _revertTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentPath = _getCurrentExpressionPath();

    return MouseRegion(
      onEnter: (_) => _triggerInteraction(),
      child: GestureDetector(
        onTap: _triggerInteraction,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.95, end: 1.0).animate(animation),
                child: child,
              ),
            );
          },
          child: Image.asset(
            currentPath,
            key: ValueKey<String>(currentPath),
            width: widget.size,
            height: widget.size,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
