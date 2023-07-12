import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodbridge_project/screens/report_screens/report_user.dart';

void main() {
  testWidgets('report listing UI', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ReportUser(
          userName: 'userName',
          userId: 'userId',
        ),
      ),
    );
    expect(find.byType(CheckboxListTile), findsNWidgets(4));
    expect(find.byType(TextFormField), findsOneWidget);
    expect(
        find.byKey(
          Key('B1'),
        ),
        findsOneWidget);
    expect(
        find.byKey(
          Key('B2'),
        ),
        findsOneWidget);
  });

  testWidgets('Submitting form with empty selected reasons or description',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
        home: ReportUser(
      userName: 'John',
      userId: '123',
    )));

    // Ensure _isSaving starts as false
    expect(find.byKey(Key('B2')), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(
        tester.widget<ElevatedButton>(find.byKey(Key('B2'))).enabled, isTrue);

    // Submit the form with empty selected reasons
    await tester.tap(find.byKey(Key('B2')));
    await tester.pumpAndSettle();

    // Verify that _isSaving remains false
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(
        tester.widget<ElevatedButton>(find.byKey(Key('B2'))).enabled, isTrue);

    // Submit the form with empty description
    await tester.enterText(find.byType(TextFormField), '');
    await tester.tap(find.byKey(Key('B2')));
    await tester.pumpAndSettle();

    // Verify that _isSaving remains false
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(
        tester.widget<ElevatedButton>(find.byKey(Key('B2'))).enabled, isTrue);
  });
}
