import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/listing.dart';
import 'listings_list_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    Stream<List<Listing>> readUserListings() {
      return FirebaseFirestore.instance
          .collection('Listings')
          .where("userId", isEqualTo: user.email)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => Listing.fromJson(doc.data()))
              .toList());
    }

    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue.shade300,
                  child: Text(
                    '${user.email!.substring(0, 2).toUpperCase()}',
                    style: TextStyle(fontSize: 40),
                  ),
                  radius: 64,
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text('Signed in as: ${user.email!}'),
                      SizedBox(
                        height: 8,
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size.fromHeight(50),
                        ),
                        icon: const Icon(Icons.arrow_back, size: 32),
                        label: const Text(
                          'Sign Out',
                          style: TextStyle(fontSize: 24),
                        ),
                        onPressed: () => FirebaseAuth.instance.signOut(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            'Your Listings',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Expanded(
            child: ListingsScreen(
              availListings: readUserListings(),
              isLikesScreenOrProfileScreen: true,
              isYourListing: true,
            ),
          ),
        ],
      ),
    );
  }
}
