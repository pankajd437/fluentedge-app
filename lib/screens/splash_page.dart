import 'package:flutter/material.dart';
import 'package:fluentedge_app/services/notification_service.dart'; // ✅ Notification service import

class SplashPage extends StatefulWidget {
  final VoidCallback onInitializationComplete;

  const SplashPage({super.key, required this.onInitializationComplete});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // ✅ Initialize notifications
      await NotificationService.init();
      await NotificationService.scheduleDailyReminder();

      // ✅ Show immediate test notification
      await NotificationService.testNowNotification(); // ⬅️ Temporary for testing
    } catch (e) {
      debugPrint("❌ Notification setup failed: $e");
    }

    // ✅ Continue to Welcome screen
    await Future.delayed(const Duration(seconds: 3));
    widget.onInitializationComplete();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FB), // ✅ App soft background
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Material(
              color: Colors.transparent,
              child: Hero(
                tag: "fluentedge-logo", // ✅ Shared Hero animation
                child: Image.asset(
                  'assets/images/FluentEdge Logo.png',
                  width: 220,
                  height: 220,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
