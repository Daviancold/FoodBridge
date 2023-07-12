import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodbridge_project/widgets/ratings.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('AverageRatings widget tests', () {
    testWidgets('AverageRatings - loading', (WidgetTester tester) async {
      Future<double> getRating() async {
        return 0;
      }

      await tester.pumpWidget(
        MaterialApp(
          home: AverageRatings(
            rating: getRating(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('AverageRatings - No reviews', (WidgetTester tester) async {
      Future<double> getRating() async {
        return 0;
      }

      await tester.pumpWidget(
        MaterialApp(
          home: AverageRatings(
            rating: getRating(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.byKey(Key('No reviews yet')), findsOneWidget);
      expect(find.byKey(Key('rating')), findsNothing);
    });

    testWidgets('AverageRatings - Have reviews', (WidgetTester tester) async {
      Future<double> getRating() async {
        return 4.0;
      }

      await tester.pumpWidget(
        MaterialApp(
          home: AverageRatings(
            rating: getRating(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.byKey(Key('No reviews yet')), findsNothing);
      expect(find.byKey(Key('rating')), findsOneWidget);
    });
  });
}
