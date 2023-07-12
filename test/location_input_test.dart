import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodbridge_project/models/listing.dart';
import 'package:foodbridge_project/widgets/location_input/location_input.dart';
import 'package:location/location.dart' as loc;
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

class MockLocation extends Mock implements loc.Location {}

class MockHttp extends Mock implements http.Client {}

void main() {
  group('LocationInput Widget', () {
    late MockLocation mockLocation;
    late MockHttp mockHttp;

    setUp(() {
      mockLocation = MockLocation();
      mockHttp = MockHttp();
    });

    testWidgets('Initial UI', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LocationInput(chosenLocation: (UserLocation? location) {}),
          ),
        ),
      );

      expect(find.byKey(Key("Type location")), findsOneWidget);
      expect(find.byKey(Key("Get location button")), findsOneWidget);
      expect(find.byKey(Key("Image placeholder")), findsOneWidget);
    });

    testWidgets('Tap Get location button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LocationInput(chosenLocation: (UserLocation? location) {}),
          ),
        ),
      );

      final getLocationButton = find.byIcon(Icons.map);
      expect(getLocationButton, findsOneWidget);

      await tester.tap(getLocationButton);
      //expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump();

      
      // await tester.pumpAndSettle();

      // Simulate the completion of fetching the current location
      // Set the location data or mock the API response accordingly
      // For example:
      // when(mockLocation.serviceEnabled()).thenAnswer((_) => Future.value(true));
      // when(mockLocation.hasPermission()).thenAnswer((_) => Future.value(loc.PermissionStatus.granted));
      // when(mockLocation.getLocation()).thenAnswer((_) => Future.value(loc.LocationData.fromMap({
      //   'latitude': 40.7128,
      //   'longitude': -74.0060,
      // })));

      // Wait for the widget to rebuild after fetching the location
      await tester.pumpAndSettle();

      // Verify that the CircularProgressIndicator is no longer displayed
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // Verify that the location preview is displayed
      expect(find.byType(Stack), findsOneWidget);

    });

  });
}
