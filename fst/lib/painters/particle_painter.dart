import 'package:flutter/material.dart';

import '../models/particle.dart';

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final opacity = (particle.life / particle.maxLife).clamp(0.0, 1.0);

      if (particle.isRing) {
        // Shockwave expansion ring
        final ringPaint = Paint()
          ..color = particle.color.withValues(alpha: opacity * 0.7)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.0 * opacity;

        canvas.drawCircle(
          Offset(particle.x, particle.y),
          particle.size,
          ringPaint,
        );
      } else if (particle.isSpark) {
        // Star spark shape
        final sparkPaint = Paint()
          ..color = particle.color.withValues(alpha: opacity)
          ..style = PaintingStyle.fill;

        canvas.drawRect(
          Rect.fromCenter(
            center: Offset(particle.x, particle.y),
            width: particle.size * opacity * 1.5,
            height: particle.size * opacity * 1.5,
          ),
          sparkPaint,
        );
      } else {
        // Standard plasma particle dot with glow
        final glowPaint = Paint()
          ..color = particle.color.withValues(alpha: opacity * 0.3)
          ..style = PaintingStyle.fill;

        canvas.drawCircle(
          Offset(particle.x, particle.y),
          particle.size * opacity * 2.0,
          glowPaint,
        );

        final corePaint = Paint()
          ..color = Colors.white.withValues(alpha: opacity)
          ..style = PaintingStyle.fill;

        canvas.drawCircle(
          Offset(particle.x, particle.y),
          particle.size * opacity * 0.6,
          corePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) {
    return true;
  }
}
