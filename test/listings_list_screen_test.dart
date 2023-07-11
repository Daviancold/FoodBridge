import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodbridge_project/models/listing.dart';
import 'package:foodbridge_project/screens/listings_list_screen.dart';
import 'package:foodbridge_project/widgets/listing_grid_item.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

class MockHttpClient extends Mock implements http.Client {
  // Implement the necessary methods and responses for your test cases.
  // For example:
  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    // Return a mock response instead of making an actual network request.
    return http.Response('Mock response', 200);
  }
}

void main() {
  // Create an instance of MockHttpClient
  MockHttpClient mockHttpClient = MockHttpClient();

  // Set up the mock response for a specific request if needed
  when(mockHttpClient.get(Uri.parse('https://example.com')))
      .thenAnswer((_) async => http.Response('Mock response', 200));
  testWidgets(
      'Empty ListingsScreen - Displays CircularProgressIndicator when waiting, then displays No available listings text',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ListingsScreen(
          availListings: Stream<List<Listing>>.empty(),
          isYourListing: false,
          isFavouritesScreen: false,
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('No available listings text')), findsOneWidget);
  });

  testWidgets('ListingsScreen - Displays error message on snapshot error',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ListingsScreen(
          availListings: Stream.error('error message'),
          isYourListing: false,
          isFavouritesScreen: false,
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('error message')), findsOneWidget);
  });

  testWidgets(
      'Error ListingsScreen - Displays CircularProgressIndicator when waiting, then displays listing grid items when available',
      (WidgetTester tester) async {
    final listings = [
      Listing(
        id: '1',
        itemName: 'itemName',
        image: 'image',
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
        userPhoto: 'userPhoto',
        addressImageUrl: 'addressImageUrl',
        isExpired: false,
        isDonorReviewed: false,
        isRecipientReviewed: false,
      ),
      Listing(
        id: '2',
        itemName: 'itemName',
        image: 'image',
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
        userPhoto: 'userPhoto',
        addressImageUrl: 'addressImageUrl',
        isExpired: false,
        isDonorReviewed: false,
        isRecipientReviewed: false,
      ),
      Listing(
        id: '3',
        itemName: 'itemName',
        image: 'image',
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
        userPhoto: 'userPhoto',
        addressImageUrl: 'addressImageUrl',
        isExpired: false,
        isDonorReviewed: false,
        isRecipientReviewed: false,
      ),
    ];

    Stream<List<Listing>> mockFetchListings() {
      return Stream.fromIterable([listings]);
    }

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListingsScreen(
            availListings: mockFetchListings(),
            isYourListing: false,
            isFavouritesScreen: false,
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('Gridview')), findsOneWidget);
  });
}
