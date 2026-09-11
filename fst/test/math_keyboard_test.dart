import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fst/widgets/math_keyboard.dart';

void main() {
  testWidgets('keyboard enters numbers', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MathKeyboard(),
        ),
      ),
    );

    await tester.tap(find.text('1').last);
    await tester.tap(find.text('2').last);
    await tester.tap(find.text('3').last);

    await tester.pump();

    expect(find.text('123'), findsOneWidget);
  });

  testWidgets('backspace removes the last digit', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MathKeyboard(),
        ),
      ),
    );

    await tester.tap(find.text('1').last);
    await tester.tap(find.text('2').last);

    await tester.tap(find.text('←'));

    await tester.pump();

    expect(find.text('12'), findsNothing);
    expect(find.text('1'), findsNWidgets(2));
  });

  testWidgets('clear removes the entire input', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MathKeyboard(),
        ),
      ),
    );

    await tester.tap(find.text('1').last);
    await tester.tap(find.text('2').last);
    await tester.tap(find.text('3').last);

    await tester.tap(find.text('C'));

    await tester.pump();

    expect(find.text('123'), findsNothing);
    expect(find.text('0'), findsNWidgets(2));
  });
}