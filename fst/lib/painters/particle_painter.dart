import 'package:flutter/material.dart';

import '../models/particle.dart';

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final opacity = (particle.life / particle.maxLife).clamp(0.0, 1.0);
      final paint = Paint()
        ..color = particle.color.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(particle.x, particle.y),
        particle.size * opacity,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) {
    return true;
  }
}
