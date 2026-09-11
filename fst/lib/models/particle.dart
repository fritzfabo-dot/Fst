import 'package:flutter/material.dart';

class Particle {
  double x;
  double y;
  double vx;
  double vy;
  double size;
  double maxLife;
  double life;
  Color color;
  bool isRing;
  bool isSpark;

  Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.size,
    required this.maxLife,
    required this.life,
    required this.color,
    this.isRing = false,
    this.isSpark = false,
  });

  bool get isDead => life <= 0;

  void update(double dt) {
    x += vx * dt * 60;
    y += vy * dt * 60;
    life -= dt;
    if (isRing) {
      size += 80 * dt;
    }
  }
}

