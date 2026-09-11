import 'dart:math';
import 'package:flutter/material.dart';

import '../models/enemy.dart';
import '../models/math_problem.dart';

class EnemyPainter extends CustomPainter {
  final MathProblem problem;
  final bool isTargeted;
  final EnemyType type;
  final double rotation;

  EnemyPainter({
    required this.problem,
    this.isTargeted = false,
    this.type = EnemyType.drone,
    this.rotation = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 1. Target Lock Reticle (if locked on by player's keyboard input)
    if (isTargeted) {
      final lockColor = const Color(0xFF00F0FF);

      // Lock aura glow
      final lockGlowPaint = Paint()
        ..color = lockColor.withValues(alpha: 0.25)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, radius + 10, lockGlowPaint);

      // Rotating Lock Reticle Ring
      final lockRingPaint = Paint()
        ..color = lockColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5;
      canvas.drawCircle(center, radius + 6, lockRingPaint);

      // Corner Crosshair Brackets
      final bracketSize = 12.0;
      final bracketPaint = Paint()
        ..color = lockColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0;

      // Top Left Corner
      canvas.drawPath(
        Path()
          ..moveTo(0, bracketSize)
          ..lineTo(0, 0)
          ..lineTo(bracketSize, 0),
        bracketPaint,
      );

      // Top Right Corner
      canvas.drawPath(
        Path()
          ..moveTo(size.width - bracketSize, 0)
          ..lineTo(size.width, 0)
          ..lineTo(size.width, bracketSize),
        bracketPaint,
      );

      // Bottom Left Corner
      canvas.drawPath(
        Path()
          ..moveTo(0, size.height - bracketSize)
          ..lineTo(0, size.height)
          ..lineTo(bracketSize, size.height),
        bracketPaint,
      );

      // Bottom Right Corner
      canvas.drawPath(
        Path()
          ..moveTo(size.width - bracketSize, size.height)
          ..lineTo(size.width, size.height)
          ..lineTo(size.width, size.height - bracketSize),
        bracketPaint,
      );
    }

    // 2. Alien Ship Hull Rendering
    canvas.save();
    canvas.translate(center.dx, center.dy);

    switch (type) {
      case EnemyType.drone:
        _drawDrone(canvas, radius);
        break;
      case EnemyType.viper:
        _drawViper(canvas, radius);
        break;
      case EnemyType.dreadnought:
        _drawDreadnought(canvas, radius);
        break;
    }

    canvas.restore();

    // 3. Math Problem Badge Tag (Crisp, Responsive & High contrast)
    final expressionText = problem.expression;
    final fontSize = expressionText.length > 7 ? 13.5 : 14.5;

    final textSpan = TextSpan(
      text: expressionText,
      style: TextStyle(
        color: isTargeted ? const Color(0xFF00F0FF) : Colors.white,
        fontSize: fontSize,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.1,
        shadows: [
          Shadow(
            color: isTargeted ? const Color(0xFF00F0FF) : const Color(0xFFA855F7),
            blurRadius: 8,
          ),
        ],
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
      maxLines: 1,
    )..layout();

    final textWidth = textPainter.width;
    final textHeight = textPainter.height;

    const horizontalPadding = 16.0;
    const verticalPadding = 7.0;

    final minBadgeWidth = max(size.width * 0.85, 54.0);
    final badgeWidth = max(textWidth + horizontalPadding, minBadgeWidth);
    final badgeHeight = max(textHeight + verticalPadding, 25.0);

    final badgeBgPaint = Paint()
      ..color = isTargeted
          ? const Color(0xFF0F172A).withValues(alpha: 0.95)
          : const Color(0xFF1E1B4B).withValues(alpha: 0.92)
      ..style = PaintingStyle.fill;

    final badgeBorderPaint = Paint()
      ..color = isTargeted ? const Color(0xFF00F0FF) : const Color(0xFFA855F7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = isTargeted ? 2.5 : 1.8;

    final badgeRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: badgeWidth,
        height: badgeHeight,
      ),
      const Radius.circular(8),
    );

    canvas.drawRRect(badgeRect, badgeBgPaint);
    canvas.drawRRect(badgeRect, badgeBorderPaint);

    textPainter.paint(
      canvas,
      Offset(
        center.dx - textWidth / 2,
        center.dy - textHeight / 2,
      ),
    );
  }

  void _drawDrone(Canvas canvas, double radius) {
    // Bio-Mechanical Sphere Drone
    final orbGradient = RadialGradient(
      colors: [
        const Color(0xFFFF0055),
        const Color(0xFF9D00FF),
        const Color(0xFF2E1065),
      ],
    );

    final paint = Paint()
      ..shader = orbGradient.createShader(
        Rect.fromCircle(center: Offset.zero, radius: radius - 4),
      );
    canvas.drawCircle(Offset.zero, radius - 4, paint);

    // Orbital Shield ring
    final ringPaint = Paint()
      ..color = const Color(0xFFFF0055).withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.save();
    canvas.rotate(rotation);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: (radius - 2) * 2, height: (radius - 8) * 2),
      ringPaint,
    );
    canvas.restore();
  }

  void _drawViper(Canvas canvas, double radius) {
    // Sharp alien interceptor triangular ship
    final path = Path()
      ..moveTo(0, radius - 4) // Point facing down
      ..lineTo(radius - 2, -radius + 4)
      ..lineTo(0, -radius / 2)
      ..lineTo(-radius + 2, -radius + 4)
      ..close();

    final viperGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color(0xFFEC4899),
        const Color(0xFF8B5CF6),
        const Color(0xFF312E81),
      ],
    );

    canvas.drawPath(
      path,
      Paint()..shader = viperGradient.createShader(Rect.fromCircle(center: Offset.zero, radius: radius)),
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFFF472B6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );
  }

  void _drawDreadnought(Canvas canvas, double radius) {
    // Heavy Armored Alien Hexagon Ship
    final path = Path();
    for (var i = 0; i < 6; i++) {
      final angle = (i * 60) * pi / 180 + rotation * 0.5;
      final r = radius - 4;
      final x = r * cos(angle);
      final y = r * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    final dreadGradient = RadialGradient(
      colors: [
        const Color(0xFFF59E0B),
        const Color(0xFFD97706),
        const Color(0xFF78350F),
      ],
    );

    canvas.drawPath(
      path,
      Paint()..shader = dreadGradient.createShader(Rect.fromCircle(center: Offset.zero, radius: radius)),
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFFFBBF24)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
  }

  @override
  bool shouldRepaint(covariant EnemyPainter oldDelegate) {
    return oldDelegate.problem != problem ||
        oldDelegate.isTargeted != isTargeted ||
        oldDelegate.type != type ||
        oldDelegate.rotation != rotation;
  }
}