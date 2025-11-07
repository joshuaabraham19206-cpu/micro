import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:micro/main.dart';

void main() {
  testWidgets('Chat screen replies to user message', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MentalHealthApp());

    // Tap the 'Start a Conversation' button on HomeScreen
    final startFinder = find.text('Start a Conversation');
    expect(startFinder, findsOneWidget);
    await tester.tap(startFinder);
    await tester.pumpAndSettle();

    // Enter a message and send
    final inputFinder = find.byType(TextField);
    expect(inputFinder, findsOneWidget);
    await tester.enterText(inputFinder, 'hello');
    await tester.testTextInput.receiveAction(TextInputAction.send);
    await tester.pump();

    // Wait for the bot reply (simulate the delayed reply)
    await tester.pump(const Duration(milliseconds: 400));

    // The bot reply for 'hello' should contain 'Hi there' according to local rules
    expect(find.textContaining('Hi there'), findsOneWidget);
  });
}
