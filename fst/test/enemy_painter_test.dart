import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:fst/models/enemy.dart';
import 'package:fst/models/math_problem.dart';
import 'package:fst/painters/enemy_painter.dart';

void main() {
  test('EnemyPainter renders short and long operations without error', () {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    const size = Size(50, 50);

    final shortProblem = MathProblem(
      left: 2,
      right: 3,
      operation: '+',
      answer: 5,
    );

    final shortPainter = EnemyPainter(
      problem: shortProblem,
      isTargeted: true,
      type: EnemyType.drone,
    );

    expect(() => shortPainter.paint(canvas, size), returnsNormally);

    final longProblem = MathProblem(
      left: 15,
      right: 18,
      operation: '+',
      answer: 33,
    );

    final longPainter = EnemyPainter(
      problem: longProblem,
      isTargeted: false,
      type: EnemyType.viper,
    );

    expect(() => longPainter.paint(canvas, size), returnsNormally);

    final picture = recorder.endRecording();
    picture.dispose();
  });
}
