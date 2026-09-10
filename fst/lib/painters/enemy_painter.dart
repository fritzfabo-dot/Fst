import 'package:flutter/material.dart';

import '../models/math_problem.dart';

class EnemyPainter extends CustomPainter {
  final MathProblem problem;

  EnemyPainter({
    required this.problem,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius = size.width / 2;

    final enemyPaint = Paint()
      ..color = Colors.deepPurpleAccent
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.purpleAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

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
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
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
    return oldDelegate.problem != problem;
  }
}