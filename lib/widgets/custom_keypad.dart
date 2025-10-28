import 'package:flutter/material.dart';

class CustomKeypad extends StatelessWidget {
  final void Function(String) onChange;
  final int maxLength;
  const CustomKeypad({super.key, required this.onChange, this.maxLength = 12});

  @override
  Widget build(BuildContext context) {
    String value = '';
    void add(String s) {
      if (value.length >= maxLength) return;
      value += s;
      onChange(value);
    }

    void del() {
      if (value.isEmpty) return;
      value = value.substring(0, value.length - 1);
      onChange(value);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 3,
          childAspectRatio: 2,
          physics: NeverScrollableScrollPhysics(),
          children: [
            for (var i = 1; i <= 9; i++) ElevatedButton(onPressed: () => add('$i'), child: Text('$i')),
            ElevatedButton(onPressed: () => add('0'), child: Text('0')),
            ElevatedButton(onPressed: del, child: Icon(Icons.backspace)),
          ],
        )
      ],
    );
  }
}
