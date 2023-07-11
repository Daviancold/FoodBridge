import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/listing.dart';
import '../screens/listings_list_screen.dart';

class LikesScreen extends StatefulWidget {
  const LikesScreen({super.key});

  @override
  State<LikesScreen> createState() => _LikesScreenState();
}

class _LikesScreenState extends State<LikesScreen> {
  String? userEmail = FirebaseAuth.instance.currentUser!.email;
  @override
  Widget build(BuildContext context) {
    Stream<List<Listing>> getFavoritesListings() {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .collection('likes')
          .where('isLiked', isEqualTo: true)
          .snapshots()
          .asyncMap((snapshot) async {
        List<Listing> favoriteListings = [];
        await Future.wait(snapshot.docs.map((doc) async {
          final listingId = doc.id;
          final listingSnapshot = await FirebaseFirestore.instance
              .collection('Listings')
              .doc(listingId)
              .get();
          if (listingSnapshot.exists) {
            favoriteListings.add(Listing.fromJson(listingSnapshot.data()!));
          }
        }));
        return favoriteListings;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorites',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: ListingsScreen(
        availListings: getFavoritesListings(),
        isYourListing: false,
        isFavouritesScreen: true,
      ),
    );
  }
}
