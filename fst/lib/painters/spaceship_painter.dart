import 'package:flutter/material.dart';

class SpaceshipPainter extends CustomPainter {
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    final centerX = size.width / 2;

    // Main body
    paint.color = Colors.blueAccent;

    final body = Path();

    body.moveTo(centerX, 5);
    body.lineTo(size.width - 10, size.height - 15);
    body.lineTo(centerX, size.height - 30);
    body.lineTo(10, size.height - 15);
    body.close();

    canvas.drawPath(body, paint);

    // Cockpit
    paint.color = Colors.cyanAccent;

    canvas.drawCircle(
      Offset(centerX, size.height * 0.38),
      13,
      paint,
    );

    // Left wing
    paint.color = Colors.blue.shade700;

    final leftWing = Path();

    leftWing.moveTo(30, 55);
    leftWing.lineTo(5, 78);
    leftWing.lineTo(32, 72);
    leftWing.close();

    canvas.drawPath(
      leftWing,
      paint,
    );

    // Right wing
    final rightWing = Path();

    rightWing.moveTo(size.width - 30, 55);
    rightWing.lineTo(size.width - 5, 78);
    rightWing.lineTo(size.width - 32, 72);
    rightWing.close();

    canvas.drawPath(
      rightWing,
      paint,
    );

    // Engine
    paint.color = Colors.orangeAccent;

    canvas.drawCircle(
      Offset(centerX, size.height - 8),
      9,
      paint,
    );
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}