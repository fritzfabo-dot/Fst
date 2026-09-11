import 'dart:math';
import 'package:flutter/material.dart';

class StarFieldPainter extends CustomPainter {
  final double totalTime;
  final int comboMultiplier;

  StarFieldPainter({
    this.totalTime = 0.0,
    this.comboMultiplier = 1,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Cosmic Nebula background glow patches
    final nebulaPaint1 = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF9D00FF).withValues(alpha: 0.15),
          const Color(0xFF00F0FF).withValues(alpha: 0.05),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.25, size.height * 0.3),
          radius: size.width * 0.5,
        ),
      );
    canvas.drawCircle(Offset(size.width * 0.25, size.height * 0.3), size.width * 0.5, nebulaPaint1);

    final nebulaPaint2 = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFF0055).withValues(alpha: 0.12),
          const Color(0xFF1A0B2E).withValues(alpha: 0.05),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.8, size.height * 0.7),
          radius: size.width * 0.6,
        ),
      );
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.7), size.width * 0.6, nebulaPaint2);

    // 2. Parallax Stars (Generated deterministically based on grid positions + time drift)
    final starSpeedMultiplier = 1.0 + (comboMultiplier - 1) * 0.5;

    final starLayers = [
      // Layer 1: Far, small, dim stars
      _StarLayer(count: 35, baseSize: 1.0, speed: 15.0 * starSpeedMultiplier, color: Colors.white.withValues(alpha: 0.35)),
      // Layer 2: Medium bright stars
      _StarLayer(count: 20, baseSize: 1.8, speed: 35.0 * starSpeedMultiplier, color: const Color(0xFF00F0FF).withValues(alpha: 0.65)),
      // Layer 3: Close twinkling stars with flares
      _StarLayer(count: 10, baseSize: 2.6, speed: 60.0 * starSpeedMultiplier, color: const Color(0xFFFFE600).withValues(alpha: 0.85)),
    ];

    final rand = Random(42);

    for (final layer in starLayers) {
      final paint = Paint()
        ..color = layer.color
        ..style = PaintingStyle.fill;

      for (var i = 0; i < layer.count; i++) {
        final baseX = rand.nextDouble() * size.width;
        final initialY = rand.nextDouble() * size.height;
        final speedFactor = 0.7 + rand.nextDouble() * 0.6;

        final dy = (initialY + totalTime * layer.speed * speedFactor) % size.height;
        final dx = baseX;

        if (layer.baseSize > 2.0) {
          // Draw bright star flare cross
          final twinkle = 0.5 + 0.5 * sin(totalTime * 4.0 + i);
          final starPaint = Paint()..color = layer.color.withValues(alpha: layer.color.a * twinkle);

          canvas.drawCircle(Offset(dx, dy), layer.baseSize * (0.8 + 0.3 * twinkle), starPaint);
          canvas.drawLine(Offset(dx - 4, dy), Offset(dx + 4, dy), starPaint..strokeWidth = 0.8);
          canvas.drawLine(Offset(dx, dy - 4), Offset(dx, dy + 4), starPaint..strokeWidth = 0.8);
        } else {
          canvas.drawCircle(Offset(dx, dy), layer.baseSize, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant StarFieldPainter oldDelegate) {
    return oldDelegate.totalTime != totalTime || oldDelegate.comboMultiplier != comboMultiplier;
  }
}

class _StarLayer {
  final int count;
  final double baseSize;
  final double speed;
  final Color color;

  _StarLayer({
    required this.count,
    required this.baseSize,
    required this.speed,
    required this.color,
  });
}
