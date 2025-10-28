import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paywave/main.dart';

void main() {
  testWidgets('App starts and shows auth', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();
    expect(find.text('Register / Login'), findsOneWidget);
  });
}
