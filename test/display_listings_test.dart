import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodbridge_project/models/listing.dart';
import 'package:foodbridge_project/screens/listings_list_screen.dart';
import 'package:foodbridge_project/widgets/listing_grid_item.dart';
import 'package:mockito/mockito.dart';

class MockStream extends Mock implements Stream<List<Listing>> {}

class MockClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

class FakeUri extends Fake implements Uri {}

void main() {
  testWidgets('Empty ListingsScreen - Displays "No available listings" text',
      (WidgetTester tester) async {
    // Create an empty stream
    final mockStream = Stream<List<Listing>>.fromIterable([]);

    await tester.pumpWidget(
      MaterialApp(
        home: ListingsScreen(
          availListings: mockStream,
          isYourListing: false,
          isFavouritesScreen: false,
        ),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('No available listings text')), findsOneWidget);
  });

  testWidgets('Empty ListingsScreen - Displays error message',
      (WidgetTester tester) async {
    // Create a custom stream that emits an error
    final controller = StreamController<List<Listing>>();
    controller.addError('Error message');
    final mockStream = controller.stream;

    await tester.pumpWidget(
      MaterialApp(
        home: ListingsScreen(
          availListings: mockStream,
          isYourListing: false,
          isFavouritesScreen: false,
        ),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('error message')), findsOneWidget);
    controller.close();
  });

  testWidgets('Non empty ListingsScreen - Displays listings in GridView',
      (WidgetTester tester) async {
    final mockClient = MockClient();
    final mockStream = Stream<List<Listing>>.fromIterable([
      [
        Listing(
          id: '1',
          itemName: 'itemName',
          image: 'https://example.com/data',
          mainCategory: 'mainCat',
          subCategory: 'subCategory',
          dietaryNeeds: 'dietaryNeeds',
          additionalNotes: 'additionalNotes',
          expiryDate: DateTime.now(),
          lat: 1.11,
          lng: 2.22,
          address: 'address',
          isAvailable: true,
          userId: 'userId',
          userName: 'userName',
          userPhoto: 'https://example.com/data',
          addressImageUrl: 'https://example.com/data',
          isExpired: false,
          isDonorReviewed: false,
          isRecipientReviewed: false,
          // Add other required properties as needed
        ),
        Listing(
          id: '2',
          itemName: 'itemName',
          image: 'https://example.com/data',
          mainCategory: 'mainCat',
          subCategory: 'subCategory',
          dietaryNeeds: 'dietaryNeeds',
          additionalNotes: 'additionalNotes',
          expiryDate: DateTime.now(),
          lat: 1.11,
          lng: 2.22,
          address: 'address',
          isAvailable: true,
          userId: 'userId',
          userName: 'userName',
          userPhoto: 'https://example.com/data',
          addressImageUrl: 'https://example.com/data',
          isExpired: false,
          isDonorReviewed: false,
          isRecipientReviewed: false,
          // Add other required properties as needed
        ),
      ]
    ]);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListingsScreen(
            availListings: mockStream,
            isYourListing: false,
            isFavouritesScreen: false,
          ),
        ),
      ),
    );

    when(mockClient.get(Uri.parse('https://example.com/data')))
        .thenAnswer((_) async => http.Response('mock response', 200));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
    // Verify that the GridView is displayed
    expect(find.byKey(const Key('Gridview')), findsOneWidget);

    // Verify that the correct number of ListingGridItem widgets are present
    //expect(find.byType(ListingGridItem), findsNWidgets(2));
  });
}
