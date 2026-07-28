import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:keymory_off/core/widgets/app_button.dart';

void main() {
  Widget buildApp({
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: AppButton(
          label: 'Continue',
          onPressed: onPressed,
          isLoading: isLoading,
        ),
      ),
    );
  }

  testWidgets('displays the given label', (tester) async {
    await tester.pumpWidget(buildApp(onPressed: () {}));

    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('calls onPressed when tapped', (tester) async {
    var tapped = false;

    await tester.pumpWidget(buildApp(onPressed: () => tapped = true));
    await tester.tap(find.byType(AppButton));
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets('shows a loading indicator instead of the label when '
      'isLoading is true', (tester) async {
    await tester.pumpWidget(buildApp(onPressed: () {}, isLoading: true));

    expect(find.text('Continue'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('does not call onPressed while isLoading is true',
      (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      buildApp(onPressed: () => tapped = true, isLoading: true),
    );
    await tester.tap(find.byType(AppButton));
    await tester.pump();

    expect(tapped, isFalse);
  });
}
