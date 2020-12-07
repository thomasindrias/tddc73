import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:steps_left/steps_left.dart';

void main() {
  var activeStep = 0;

  List<StepsLeftItem> steps = [
    StepsLeftItem(
      label: "Order placed",
    ),
    StepsLeftItem(label: "Review"),
    StepsLeftItem(label: "Order"),
    StepsLeftItem(label: "Shipped"),
    StepsLeftItem(label: "Delivered"),
  ];

  // Run tests
  testWidgets("Testing Steps Left", (WidgetTester tester) async {
    //Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
            body: StepsLeftBar(
          activeStep: activeStep,
          children: steps,
        )),
      ),
    );

    // For all steps, check if
    for (StepsLeftItem step in steps) {
      //final labelFinder = find.text(step.label);
      final stepItemFinder = find.byKey(Key(step.label));

      await tester.ensureVisible(stepItemFinder);
      expect(stepItemFinder, findsOneWidget);
    }
  });
}
