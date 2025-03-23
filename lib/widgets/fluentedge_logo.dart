import 'package:flutter/material.dart';

class FluentEdgeLogo extends StatelessWidget {
  const FluentEdgeLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(180, 80), // Adjust logo size
      painter: _FluentEdgeLogoPainter(),
    );
  }
}

class _FluentEdgeLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0052CC) // Deep Blue Primary Color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final textPainter = TextPainter(
      text: const TextSpan(
        text: "Fluent",
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
          color: Colors.black,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(canvas, Offset(0, 20));

    final textPainter2 = TextPainter(
      text: const TextSpan(
        text: "Edge",
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
          color: Color(0xFFFFC107), // Golden Yellow Accent
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter2.layout();
    textPainter2.paint(canvas, Offset(110, 20));

    // Draw an elegant curved underline
    final path = Path()
      ..moveTo(0, size.height - 10)
      ..quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 10);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
