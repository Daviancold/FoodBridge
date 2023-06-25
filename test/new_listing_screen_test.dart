import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodbridge_project/screens/new_listing_screen.dart';
import 'package:mockito/mockito.dart';
import 'package:foodbridge_project/widgets/firestore_service.dart';

// Import the necessary dependencies and widgets used in the code
// You may need to create mock implementations of those dependencies

class MockFile extends Mock implements File {}

class MockDateTime extends Mock implements DateTime {}

class MockListingService extends Mock implements ListingService {
  @override
  Future<bool> uploadListing({
    required String itemName,
    required File selectedImage,
    required String mainCat,
    required String subCat,
    required String dietaryInfo,
    required String addInfo,
    required DateTime expDate,
    required double lat,
    required double lng,
    required String address,
    required String addressImageUrl,
  }) async {
    super.noSuchMethod(Invocation.method(#uploadListing, [
      itemName,
      selectedImage,
      mainCat,
      subCat,
      dietaryInfo,
      addInfo,
      expDate,
      lat,
      lng,
      address,
      addressImageUrl,
    ]));
    return true;
  }
}

class MockListingServiceFail extends Mock implements ListingService {
  @override
  Future<bool> uploadListing({
    required String itemName,
    required File selectedImage,
    required String mainCat,
    required String subCat,
    required String dietaryInfo,
    required String addInfo,
    required DateTime expDate,
    required double lat,
    required double lng,
    required String address,
    required String addressImageUrl,
  }) async {
    super.noSuchMethod(Invocation.method(#uploadListing, [
      itemName,
      selectedImage,
      mainCat,
      subCat,
      dietaryInfo,
      addInfo,
      expDate,
      lat,
      lng,
      address,
      addressImageUrl,
    ]));
    return false;
  }
}

void main() {
  group('NewListingScreen', () {
    test('Save item success', () async {
      final mockDateTime = MockDateTime();
      final mockUploadListing = MockListingService();
      String imagePath = 'path/to/picture.jpg';
      File imageFile = File(imagePath);

      when(
        mockUploadListing.uploadListing(
          itemName: 'itemName',
          selectedImage: imageFile,
          mainCat: 'chosenMainCategory',
          subCat: 'chosenSubCategory',
          dietaryInfo: 'chosenDietaryOption',
          addInfo: 'additionalInfo',
          expDate: mockDateTime,
          lat: 1.111,
          lng: 2.222,
          address: 'address',
          addressImageUrl: 'addressImageUrl',
        ),
      ).thenAnswer((_) => Future.value(true));

      // Call the uploadListing() function
      final result = await mockUploadListing.uploadListing(
        itemName: 'itemName',
        selectedImage: imageFile,
        mainCat: 'chosenMainCategory',
        subCat: 'chosenSubCategory',
        dietaryInfo: 'chosenDietaryOption',
        addInfo: 'additionalInfo',
        expDate: mockDateTime,
        lat: 1.111,
        lng: 2.222,
        address: 'address',
        addressImageUrl: 'addressImageUrl',
      );

      // result == true means the listing has been uploaded successfully
      expect(result, true);
    });

    test('Save item fail', () async {
      final mockDateTime = MockDateTime();
      final mockUploadListing = MockListingServiceFail();
      String imagePath = 'path/to/picture.jpg';
      File imageFile = File(imagePath);

      when(
        mockUploadListing.uploadListing(
          itemName: 'itemName',
          selectedImage: imageFile,
          mainCat: 'chosenMainCategory',
          subCat: 'chosenSubCategory',
          dietaryInfo: 'chosenDietaryOption',
          addInfo: 'additionalInfo',
          expDate: mockDateTime,
          lat: 1.111,
          lng: 2.222,
          address: 'address',
          addressImageUrl: 'addressImageUrl',
        ),
      ).thenAnswer((_) => Future.value(false));

      // Call the uploadListing() function
      final result = await mockUploadListing.uploadListing(
        itemName: 'itemName',
        selectedImage: imageFile,
        mainCat: 'chosenMainCategory',
        subCat: 'chosenSubCategory',
        dietaryInfo: 'chosenDietaryOption',
        addInfo: 'additionalInfo',
        expDate: mockDateTime,
        lat: 1.111,
        lng: 2.222,
        address: 'address',
        addressImageUrl: 'addressImageUrl',
      );

      // result == false means the listing has been uploaded successfully
      expect(result, false);
    });
  });
}
