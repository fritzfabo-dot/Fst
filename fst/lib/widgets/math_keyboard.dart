import 'package:flutter/material.dart';

class MathKeyboard extends StatelessWidget {
  const MathKeyboard({
    super.key,
    this.input = '',
    this.onChanged,
  });

  final String input;
  final ValueChanged<String>? onChanged;

  void addDigit(String digit) {
    onChanged?.call(input + digit);
  }

  void backspace() {
    if (input.isEmpty) {
      return;
    }

    onChanged?.call(
      input.substring(0, input.length - 1),
    );
  }

  void clear() {
    if (input.isEmpty) {
      return;
    }

    onChanged?.call('');
  }

  Widget buildKey({
    required String label,
    required VoidCallback onTap,
    bool destructive = false,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: destructive
                  ? Colors.redAccent.withOpacity(0.8)
                  : Colors.white.withOpacity(0.10),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.white.withOpacity(0.18),
              ),
            ),
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 330,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.65),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.cyanAccent.withOpacity(0.35),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.cyanAccent.withOpacity(0.12),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Built-in display
          Container(
            width: double.infinity,
            height: 42,
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(7),
              border: Border.all(
                color: Colors.cyanAccent.withOpacity(0.4),
              ),
            ),
            alignment: Alignment.centerRight,
            child: Text(
              input.isEmpty ? '0' : input,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.cyanAccent,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),

          // First row
          Row(
            children: [
              buildKey(
                label: '1',
                onTap: () => addDigit('1'),
              ),
              buildKey(
                label: '2',
                onTap: () => addDigit('2'),
              ),
              buildKey(
                label: '3',
                onTap: () => addDigit('3'),
              ),
              buildKey(
                label: '4',
                onTap: () => addDigit('4'),
              ),
              buildKey(
                label: '5',
                onTap: () => addDigit('5'),
              ),
              buildKey(
                label: '6',
                onTap: () => addDigit('6'),
              ),
            ],
          ),

          // Second row
          Row(
            children: [
              buildKey(
                label: '7',
                onTap: () => addDigit('7'),
              ),
              buildKey(
                label: '8',
                onTap: () => addDigit('8'),
              ),
              buildKey(
                label: '9',
                onTap: () => addDigit('9'),
              ),
              buildKey(
                label: '0',
                onTap: () => addDigit('0'),
              ),
              buildKey(
                label: '←',
                onTap: backspace,
              ),
              buildKey(
                label: 'C',
                onTap: clear,
                destructive: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}