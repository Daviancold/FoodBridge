import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/listing.dart';

class FirestoreService {
  Future<void> createListing({
    required String itemName,
    required String urlLink,
    required String mainCat,
    required String subCat,
    required String dietaryInfo,
    required String addInfo,
    required DateTime expDate,
    required double lat,
    required double lng,
    required String address,
    required String email,
    required String userName,
    required String addressImageUrl,
    required String userPhoto,
  }) async {
    final docListing = FirebaseFirestore.instance.collection('Listings').doc();

    final listing = Listing(
      id: docListing.id,
      itemName: itemName,
      image: urlLink,
      mainCategory: mainCat,
      subCategory: subCat,
      dietaryNeeds: dietaryInfo,
      additionalNotes: addInfo,
      expiryDate: expDate,
      lat: lat,
      lng: lng,
      address: address,
      isAvailable: true,
      userId: email,
      userName: userName,
      addressImageUrl: addressImageUrl,
      userPhoto: userPhoto,
    );

    final json = listing.toJson();
    await docListing.set(json);
  }

  static Future<void> updateListing(Map<String, dynamic> data, String docId) async {
    final docListing =
        FirebaseFirestore.instance.collection('Listings').doc(docId);

    await docListing.update(data);
  }
}