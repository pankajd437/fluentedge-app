import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  final VoidCallback onInitializationComplete;

  const SplashPage({super.key, required this.onInitializationComplete});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // ✅ Simulate initialization or replace with real logic
      await Future.delayed(const Duration(seconds: 2));

      // ✅ Initialization complete
      widget.onInitializationComplete();
    } catch (e) {
      debugPrint('⚠️ Initialization error: $e');
      // Optionally show retry UI or fallback screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FB),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // ✅ Attempt to load splash image
            Image.asset(
              'assets/images/splash_logo.png',
              width: 200,
              height: 200,
              errorBuilder: (context, error, stackTrace) {
                debugPrint('⚠️ Image loading error: $error');
                return const Icon(Icons.error_outline, size: 80, color: Colors.redAccent);
              },
            ),

            // ✅ Safe loader in case image fails or takes time
            const Positioned(
              bottom: 50,
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
