import 'enemy.dart';

class Bullet {
  double x;
  double y;

  final double speed;

  Enemy? target;

  Bullet({
    required this.x,
    required this.y,
    required this.speed,
    this.target,
  });
}