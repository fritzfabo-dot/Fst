import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fst/widgets/math_keyboard.dart';

class TestKeyboard extends StatefulWidget {
  const TestKeyboard({super.key});

  @override
  State<TestKeyboard> createState() => _TestKeyboardState();
}

class _TestKeyboardState extends State<TestKeyboard> {
  String input = '';

  @override
  Widget build(BuildContext context) {
    return MathKeyboard(
      input: input,
      onChanged: (value) {
        setState(() {
          input = value;
        });
      },
    );
  }
}

void main() {
  testWidgets('keyboard enters numbers', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: TestKeyboard(),
        ),
      ),
    );

    await tester.tap(find.text('1').last);
    await tester.pump();

    await tester.tap(find.text('2').last);
    await tester.pump();

    await tester.tap(find.text('3').last);
    await tester.pump();

    expect(
      find.text('123'),
      findsOneWidget,
    );
  });

  testWidgets('backspace removes the last digit', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: TestKeyboard(),
        ),
      ),
    );

    await tester.tap(find.text('1').last);
    await tester.pump();

    await tester.tap(find.text('2').last);
    await tester.pump();

    expect(
      find.text('12'),
      findsOneWidget,
    );

    await tester.tap(find.text('←'));
    await tester.pump();

    expect(
      find.text('12'),
      findsNothing,
    );

    expect(
  find.text('1'),
  findsNWidgets(2),
);
  });

  testWidgets('clear removes the entire input', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: TestKeyboard(),
        ),
      ),
    );

    await tester.tap(find.text('1').last);
    await tester.pump();

    await tester.tap(find.text('2').last);
    await tester.pump();

    await tester.tap(find.text('3').last);
    await tester.pump();

    expect(
      find.text('123'),
      findsOneWidget,
    );

    await tester.tap(find.text('C'));
    await tester.pump();

    expect(
      find.text('123'),
      findsNothing,
    );

    expect(
      find.text('0'),
      findsNWidgets(2),
    );
  });
}