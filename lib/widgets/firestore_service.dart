import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodbridge_project/widgets/utils.dart';
import '../models/listing.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

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
      isExpired: false,
    );

    final json = listing.toJson();
    await docListing.set(json);
  }

  static Future<void> updateListing(
      Map<String, dynamic> data, String docId) async {
    final docListing =
        FirebaseFirestore.instance.collection('Listings').doc(docId);

    await docListing.update(data);
  }
}

class FirebaseStorageService {
  Future<String> uploadImage(File file) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('listingImages/$fileName');

    await ref.putFile(file);

    String imageUrl = await ref.getDownloadURL();
    return imageUrl;
  }

  Future<void> deleteFileByUrl(String fileUrl) async {
    Uri uri = Uri.parse(fileUrl);
    String filePath = uri.path;
    String decodedFilePath = Uri.decodeComponent(filePath);
    String fileName =
        decodedFilePath.substring(decodedFilePath.lastIndexOf('/') + 1);

    await deleteFile('listingImages/$fileName');

    print('File deleted successfully');
  }

  Future<void> deleteFile(String filePath) async {
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref().child(filePath);
    await ref.delete();
  }
}

class ListingService {
  Future<bool> uploadListing({
    required String itemName,
    required File selectedImage,
    // required String urlLink,
    required String mainCat,
    required String subCat,
    required String dietaryInfo,
    required String addInfo,
    required DateTime expDate,
    required double lat,
    required double lng,
    required String address,
    // required String email,
    // required String userName,
    // required String userPhoto,
    required String addressImageUrl,
  }) async {
    try {
      FirebaseStorageService imageService = FirebaseStorageService();
      final urlLink = await imageService.uploadImage(selectedImage);
      final user = FirebaseAuth.instance.currentUser!;

      FirestoreService firestoreService = FirestoreService();
      await firestoreService.createListing(
        itemName: itemName,
        urlLink: urlLink,
        mainCat: mainCat,
        subCat: subCat,
        dietaryInfo: dietaryInfo,
        addInfo: addInfo,
        expDate: expDate,
        lat: lat,
        lng: lng,
        address: address,
        email: user.email!,
        userName: user.displayName!,
        userPhoto: user.photoURL!,
        addressImageUrl: addressImageUrl,
      );
      return true;
    } catch (e) {
      Utils.showSnackBar('error: $e');
      return false;
    }
  }
  
}
