import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodbridge_project/widgets/profile_appbar.dart';
import '../../models/listing.dart';
import '../listings_list_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OthersProfileScreen extends ConsumerWidget {
  const OthersProfileScreen({
    super.key,
    required this.userId,
    required this.userName,
    required this.userPhoto,
  });

  final String userId;
  final String userName;
  final String userPhoto;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser!;

    Stream<List<Listing>> readUserListings() {
      return FirebaseFirestore.instance
          .collection('Listings')
          .where("userId", isEqualTo: userId)
          .orderBy("expiryDate", descending: true)
          .orderBy("isAvailable", descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => Listing.fromJson(doc.data()))
              .toList());
    }

    return Scaffold(
      appBar: ProfileAppBar(context),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 64,
                  backgroundColor: Colors.grey,
                  child: CircleAvatar(
                    radius: 62,
                    backgroundImage: NetworkImage(userPhoto),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Username:',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontSize: 14),
                          ),
                          const SizedBox(width: 4),
                          Text(userName,
                              style: Theme.of(context).textTheme.bodyMedium!),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        icon: const Icon(Icons.warning, size: 32),
                        label: const Text(
                          'Report',
                          style: TextStyle(fontSize: 24),
                        ),
                        onPressed: () {},
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            '${userName}\'s Listings',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Expanded(
            child: ListingsScreen(
              availListings: readUserListings(),
              isYourListing: false,
            ),
          ),
        ],
      ),
    );
  }
}
