import 'package:flutter/material.dart';

class FloatingText {
  double x;
  double y;
  final String text;
  final Color color;
  double life;
  final double maxLife;

  FloatingText({
    required this.x,
    required this.y,
    required this.text,
    required this.color,
    this.life = 0.8,
    this.maxLife = 0.8,
  });

  bool get isDead => life <= 0;

  void update(double dt) {
    y -= 40 * dt;
    life -= dt;
  }
}
