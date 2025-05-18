import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedMentorWidget extends StatefulWidget {
  final String expressionName; // e.g. 'mentor_processing.png'
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

class _AnimatedMentorWidgetState extends State<AnimatedMentorWidget>
    with SingleTickerProviderStateMixin {
  final List<String> expressions = [
    'mentor_analytical_upper.png',
    'mentor_audio_ready_upper.png',
    'mentor_celebrate_full.png',
    'mentor_confused_upper.png',
    'mentor_curious_upper.png',
    'mentor_encouraging_upper.png',
    'mentor_excited_full.png',
    'mentor_pointing_full.png',
    'mentor_proud_full.png',
    'mentor_reassure_upper.png',
    'mentor_sad_upper.png',
    'mentor_silly_upper.png',
    'mentor_sleepy_upper.png',
    'mentor_surprised_upper.png',
    'mentor_thinking_upper.png',
    'mentor_thumbs_up_full.png',
    'mentor_tip_upper.png',
    'mentor_wave_smile_full.png',
  ];

  late String _currentPath;
  Timer? _switchTimer;

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _opacityAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _setInitialPath();
    _controller.forward();

    if (widget.loop && widget.expressionName.isEmpty) {
      _startLoop();
    }
  }

  void _setInitialPath() {
    _currentPath = _buildAssetPath(widget.expressionName);
    debugPrint("🧠 Initial mentor image: $_currentPath");
  }

  void _startLoop() {
    _switchTimer = Timer.periodic(widget.idleSwitchDuration, (_) {
      final randomExpression = expressions[Random().nextInt(expressions.length)];
      final path = _buildAssetPath(randomExpression);
      debugPrint("🔁 Loop mentor image: $path");
      setState(() {
        _currentPath = path;
        _controller.forward(from: 0);
      });
    });
  }

  String _buildAssetPath(String name) {
    return 'assets/images/mentor_expressions/$name';
  }

  @override
  void didUpdateWidget(covariant AnimatedMentorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.expressionName != oldWidget.expressionName) {
      setState(() {
        _currentPath = _buildAssetPath(widget.expressionName);
        debugPrint("🔄 Updated mentor image: $_currentPath");
      });
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _switchTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
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
      ),
    );
  }
}