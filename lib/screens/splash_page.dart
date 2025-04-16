import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:fluentedge_app/services/notification_service.dart';

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
      duration: const Duration(milliseconds: 1000),
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
      await NotificationService.init();
      await NotificationService.scheduleDailyReminder();

      // ✅ Uncomment for test notification if needed
      // await NotificationService.testNowNotification();
    } catch (e) {
      debugPrint("❌ Notification setup failed: $e");
    }

    await Future.delayed(const Duration(seconds: 1));
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
      backgroundColor: const Color(0xFFF2F6FB),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ✅ Hero for future transition
                Hero(
                  tag: "fluentedge-logo",
                  child: Image.asset(
                    'assets/images/FluentEdge Logo.png',
                    width: 160,
                    height: 160,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 16),

                // ✅ Optional Lottie flair
                Lottie.asset(
                  'assets/animations/ai_mentor_welcome.json',
                  width: 160,
                  height: 160,
                  fit: BoxFit.contain,
                  repeat: true,
                ),

                const SizedBox(height: 12),
                const Text(
                  "Welcome to FluentEdge",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1565C0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
