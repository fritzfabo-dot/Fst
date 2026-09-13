import 'dart:math';
import 'package:flutter/material.dart';

import '../models/game_theme.dart';

class SpaceshipPainter extends CustomPainter {
  final double totalTime;
  final GameTheme theme;

  SpaceshipPainter({
    this.totalTime = 0.0,
    this.theme = GameTheme.cyberpunkNeon,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // 1. Shield Energy Aura Glow
    final shieldPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          theme.primaryColor.withValues(alpha: 0.28),
          theme.primaryColor.withValues(alpha: 0.05),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(centerX, centerY),
          radius: size.width * 0.55,
        ),
      );
    canvas.drawCircle(Offset(centerX, centerY), size.width * 0.55, shieldPaint);

    // 2. Animated Plasma Thruster Engine Flames
    final flameFlicker = sin(totalTime * 30.0) * 4.0;
    final flameHeight = 22.0 + flameFlicker;

    // Left Thruster Flame
    final leftFlamePath = Path()
      ..moveTo(centerX - 16, size.height - 18)
      ..lineTo(centerX - 24, size.height - 18)
      ..lineTo(centerX - 20, size.height - 18 + flameHeight)
      ..close();

    final flameGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        theme.primaryColor,
        theme.secondaryColor,
        Colors.transparent,
      ],
    );

    final flamePaint = Paint()
      ..shader = flameGradient.createShader(
        Rect.fromLTWH(centerX - 24, size.height - 18, 8, flameHeight),
      );
    canvas.drawPath(leftFlamePath, flamePaint);

    // Right Thruster Flame
    final rightFlamePath = Path()
      ..moveTo(centerX + 16, size.height - 18)
      ..lineTo(centerX + 24, size.height - 18)
      ..lineTo(centerX + 20, size.height - 18 + flameHeight)
      ..close();

    final rightFlamePaint = Paint()
      ..shader = flameGradient.createShader(
        Rect.fromLTWH(centerX + 16, size.height - 18, 8, flameHeight),
      );
    canvas.drawPath(rightFlamePath, rightFlamePaint);

    // Core Engine Center Flame
    final centerFlamePath = Path()
      ..moveTo(centerX - 8, size.height - 16)
      ..lineTo(centerX + 8, size.height - 16)
      ..lineTo(centerX, size.height - 12 + flameHeight * 1.2)
      ..close();

    final centerFlamePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white,
          theme.primaryColor,
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromLTWH(centerX - 8, size.height - 16, 16, flameHeight * 1.2),
      );
    canvas.drawPath(centerFlamePath, centerFlamePaint);

    // 3. Main Wings & Fuselage (Gradient Metallic)
    final mainBody = Path()
      ..moveTo(centerX, 4) // Nose tip
      ..lineTo(size.width - 6, size.height - 20) // Right Wingtip
      ..lineTo(size.width - 22, size.height - 28) // Right wing inner
      ..lineTo(centerX + 12, size.height - 14) // Right tail
      ..lineTo(centerX, size.height - 18) // Rear center indent
      ..lineTo(centerX - 12, size.height - 14) // Left tail
      ..lineTo(22, size.height - 28) // Left wing inner
      ..lineTo(6, size.height - 20) // Left Wingtip
      ..close();

    final hullGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: theme.shipHullGradient,
    );

    canvas.drawPath(
      mainBody,
      Paint()..shader = hullGradient.createShader(Offset.zero & size),
    );

    // Neon Hull Trim Lines
    final trimPaint = Paint()
      ..color = theme.shipTrimColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawPath(mainBody, trimPaint);

    // 4. Wingtip Laser Cannons
    final cannonPaint = Paint()..color = theme.secondaryColor;
    canvas.drawRect(Rect.fromLTWH(4, size.height - 35, 4, 18), cannonPaint);
    canvas.drawRect(Rect.fromLTWH(size.width - 8, size.height - 35, 4, 18), cannonPaint);

    // 5. Cockpit Visor (Glassmorphic Glow)
    final cockpitPath = Path()
      ..moveTo(centerX, 20)
      ..lineTo(centerX + 14, 45)
      ..lineTo(centerX, 52)
      ..lineTo(centerX - 14, 45)
      ..close();

    final cockpitGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: theme.cockpitGradient,
    );

    canvas.drawPath(
      cockpitPath,
      Paint()..shader = cockpitGradient.createShader(Offset.zero & size),
    );

    // Cockpit Glint/Highlight
    final glintPath = Path()
      ..moveTo(centerX - 4, 25)
      ..lineTo(centerX + 2, 25)
      ..lineTo(centerX - 2, 42)
      ..close();
    canvas.drawPath(glintPath, Paint()..color = Colors.white.withValues(alpha: 0.7));
  }

  @override
  bool shouldRepaint(covariant SpaceshipPainter oldDelegate) {
    return oldDelegate.totalTime != totalTime || oldDelegate.theme != theme;
  }
}