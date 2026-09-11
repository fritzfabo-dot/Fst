import 'package:flutter/material.dart';

import '../models/math_problem.dart';

class EnemyPainter extends CustomPainter {
  final MathProblem problem;
  final bool isTargeted;

  EnemyPainter({
    required this.problem,
    this.isTargeted = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius = size.width / 2;

    // Halo/Réticule de ciblage si l'ennemi est verrouillé
    if (isTargeted) {
      final lockPaint = Paint()
        ..color = Colors.cyanAccent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;

      canvas.drawCircle(
        center,
        radius + 4,
        lockPaint,
      );

      final glowPaint = Paint()
        ..color = Colors.cyanAccent.withOpacity(0.3)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        center,
        radius + 6,
        glowPaint,
      );
    }

    final enemyPaint = Paint()
      ..color = isTargeted ? Colors.deepPurple : Colors.deepPurpleAccent
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = isTargeted ? Colors.cyanAccent : Colors.purpleAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = isTargeted ? 4 : 3;

    canvas.drawCircle(
      center,
      radius - 2,
      enemyPaint,
    );

    canvas.drawCircle(
      center,
      radius - 2,
      borderPaint,
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text: problem.expression,
        style: TextStyle(
          color: isTargeted ? Colors.cyanAccent : Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout(
      maxWidth: size.width - 8,
    );

    textPainter.paint(
      canvas,
      Offset(
        (size.width - textPainter.width) / 2,
        (size.height - textPainter.height) / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(
    covariant EnemyPainter oldDelegate,
  ) {
    return oldDelegate.problem != problem || oldDelegate.isTargeted != isTargeted;
  }
}