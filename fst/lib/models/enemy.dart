import 'math_problem.dart';

enum EnemyType {
  drone,
  viper,
  dreadnought,
}

class Enemy {
  double x;
  double y;

  final double speed;
  final double size;
  final MathProblem problem;
  final EnemyType type;
  double rotation;

  Enemy({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.problem,
    this.type = EnemyType.drone,
    this.rotation = 0.0,
  });
}