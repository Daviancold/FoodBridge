import 'package:flutter_test/flutter_test.dart';
import 'package:foodbridge_project/models/listing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  // TODO: Implement test
  group('Listing Model', () {
    test('fromJson() converts JSON to Listing object', () {
      final json = {
        'id': '123',
        'itemName': 'Item',
        'userName': 'John Doe',
        'userId': 'johndoe@example.com',
        'userPhoto': 'path/to/photo.jpg',
        'image': 'path/to/image.jpg',
        'mainCategory': 'beverages',
        'subCategory': 'coffee',
        'dietaryNeeds': 'halal',
        'additionalNotes': 'Some notes',
        'expiryDate': Timestamp.now(),
        'isAvailable': true,
        'lat': 37.7749,
        'lng': -122.4194,
        'address': '123 Main St',
        'addressImageUrl': 'path/to/address/image.jpg',
      };

      final listing = Listing.fromJson(json);

      expect(listing.id, '123');
      expect(listing.itemName, 'Item');
      expect(listing.userName, 'John Doe');
      expect(listing.userId, 'johndoe@example.com');
      expect(listing.userPhoto, 'path/to/photo.jpg');
      expect(listing.image, 'path/to/image.jpg');
      expect(listing.mainCategory, 'beverages');
      expect(listing.subCategory, 'coffee');
      expect(listing.dietaryNeeds, 'halal');
      expect(listing.additionalNotes, 'Some notes');
      expect(listing.expiryDate, isA<DateTime>());
      expect(listing.isAvailable, true);
      expect(listing.lat, 37.7749);
      expect(listing.lng, -122.4194);
      expect(listing.address, '123 Main St');
      expect(listing.addressImageUrl, 'path/to/address/image.jpg');
    });

    test('toJson() converts Listing object to JSON', () {
      final listing = Listing(
        id: '123',
        itemName: 'Item',
        userName: 'John Doe',
        userId: 'johndoe@example.com',
        userPhoto: 'path/to/photo.jpg',
        image: 'path/to/image.jpg',
        mainCategory: 'beverages',
        subCategory: 'coffee',
        dietaryNeeds: 'halal',
        additionalNotes: 'Some notes',
        expiryDate: DateTime.now(),
        isAvailable: true,
        lat: 37.7749,
        lng: -122.4194,
        address: '123 Main St',
        addressImageUrl: 'path/to/address/image.jpg',
      );

      final json = listing.toJson();

      expect(json['id'], '123');
      expect(json['itemName'], 'Item');
      expect(json['userName'], 'John Doe');
      expect(json['userId'], 'johndoe@example.com');
      expect(json['userPhoto'], 'path/to/photo.jpg');
      expect(json['image'], 'path/to/image.jpg');
      expect(json['mainCategory'], 'beverages');
      expect(json['subCategory'], 'coffee');
      expect(json['dietaryNeeds'], 'halal');
      expect(json['additionalNotes'], 'Some notes');
      expect(json['expiryDate'], isA<DateTime>());
      expect(json['isAvailable'], true);
      expect(json['lat'], 37.7749);
      expect(json['lng'], -122.4194);
      expect(json['address'], '123 Main St');
      expect(json['addressImageUrl'], 'path/to/address/image.jpg');
    });
  });
}
