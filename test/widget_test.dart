import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pbmuas/main.dart';

void main() {
  testWidgets('App loads splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Splash Screen'), findsOneWidget);
  });
}
