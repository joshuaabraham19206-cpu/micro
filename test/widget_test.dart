// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:micro/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame using the real app class.
    await tester.pumpWidget(const MentalHealthApp());

    // Verify the main screen is present by checking for the Home label in the BottomNavigationBar.
    expect(find.text('Home'), findsOneWidget);
  });
}
