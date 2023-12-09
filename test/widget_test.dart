import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobilitymate/main.dart';

void main() {
  testWidgets('Speech recognition UI test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that the app title is rendered.
    expect(find.text('Mobility Mate'), findsOneWidget);

    // Verify that initial recognized words are not present.
    expect(find.text('Recognized words'), findsOneWidget);
    expect(find.text(''), findsOneWidget);

    // Tap the microphone button to start listening.
    await tester.tap(find.byIcon(Icons.mic));
    await tester.pump();

    // Verify that the app is now listening.
    expect(find.text('Tap the microphone to start listening...'), findsOneWidget);

    // Simulate a speech result.
    await tester.pumpWidget(MyApp());

    // Verify that the recognized words are displayed.
    expect(find.text('Recognized words'), findsOneWidget);
    expect(find.text('YourSpeechResult'), findsOneWidget);

    // Tap the send button to share the result.
    await tester.tap(find.byIcon(Icons.send));
    await tester.pump();

    // Verify that the share action is triggered.

    // You can add more test scenarios based on your app's functionality.
  });
}
