/*
    Widget testing, which tests UI elements without firing up the app on an emulator
    or device, instead just keeping track of everything that is supposed to be on
    screen and letting us interact with it in a way that is much simpler and faster
    than is done in integration tests.
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calc_app/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(CalculatorApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('grid existence test', (WidgetTester tester) async {
    await tester.pumpWidget(CalculatorApp());

    // 1. There should be two widgets containing the 0 string: the calculator
    // screen at the start and the zero button.
    expect(find.text('0'), findsNWidgets(2));

    // 2. The numbers from 1 to 10 can be found by simply using a for loop
    for (int i = 1; i < 10; i++) {
      expect(find.text('$i'), findsOneWidget);
    }

    // 3. Just writing the instruction to look for each symbol separately.
    ['+', '-', 'x', '<-', 'C'].forEach(
      (str) => expect(find.text(str), findsOneWidget),
    );

    /*
        We can judge ourselves whether the widget matches what we want, which
        means we can focus just on what we need: we need the widget in question
        to be an image and we want it to be displaying icons/divide.png from the
        assets
     */
    expect(find.byElementPredicate((element) {
      if (!(element.widget is Image))
        return false;
      else if ((element.widget as Image).image ==
          AssetImage("icons/divide.png"))
        return true;
      else
        return false;
    }), findsOneWidget);
  });
}
