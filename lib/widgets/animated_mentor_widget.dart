import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedMentorWidget extends StatefulWidget {
  final String expressionName; // e.g., 'mentor_tip_upper.png'
  final double size;
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
    'mentor_alert_upper.png',
    'mentor_thinking_upper.png',
    'mentor_tip_upper.png',
    'mentor_encouraging_upper.png',
    'mentor_confused_upper.png',
    'mentor_proud_full.png',
    'mentor_sad_upper.png',
    'mentor_wave_smile_full.png',
  ];

  late String _currentPath;
  Timer? _switchTimer;

  @override
  void initState() {
    super.initState();
    _setInitialPath();

    if (widget.loop && widget.expressionName.isEmpty) {
      _startLoop();
    }
  }

  void _setInitialPath() {
    _currentPath = _buildAssetPath(widget.expressionName);
  }

  @override
  void didUpdateWidget(covariant AnimatedMentorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.expressionName != oldWidget.expressionName) {
      setState(() {
        _currentPath = _buildAssetPath(widget.expressionName);
      });
    }
  }

  void _startLoop() {
    _switchTimer = Timer.periodic(widget.idleSwitchDuration, (_) {
      final random = expressions[Random().nextInt(expressions.length)];
      setState(() => _currentPath = _buildAssetPath(random));
    });
  }

  String _buildAssetPath(String name) {
    final normalized = name.toLowerCase().replaceAll(' ', '_');
    return 'assets/images/mentor_expressions/$normalized';
  }

  @override
  void dispose() {
    _switchTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.9, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.size * 0.5),
            child: Image.asset(
              _currentPath,
              width: widget.size,
              height: widget.size,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) {
                debugPrint("❌ Mentor image not found: $_currentPath");
                return Container(
                  width: widget.size,
                  height: widget.size,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade200,
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
