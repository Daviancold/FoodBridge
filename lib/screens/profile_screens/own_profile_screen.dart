import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/listing.dart';
import '../listings_list_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser!;

    Stream<List<Listing>> readUserListings() {
      final now = DateTime.now();
      final user = FirebaseAuth.instance.currentUser;

      return FirebaseFirestore.instance
          .collection('Listings')
          .where('userId', isEqualTo: user!.email)
          .orderBy('isExpired', descending: false)
          .orderBy('isAvailable', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final expiryDate = data['expiryDate'] as Timestamp;
                final isExpired = expiryDate.toDate().isBefore(now);

                // Update the 'isExpired' field in the document if necessary
                if (isExpired != data['isExpired']) {
                  doc.reference.update({'isExpired': isExpired});
                }

                return Listing.fromJson(data);
              }).toList());
    }

    return Scaffold(
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
                    backgroundImage: NetworkImage(user.photoURL.toString()),
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
                            'Signed in as:',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontSize: 14),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              user.email!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: Theme.of(context).textTheme.bodyMedium!,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
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
                          Expanded(
                            child: Text(user.displayName!,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: Theme.of(context).textTheme.bodyMedium!),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
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
          const SizedBox(
            height: 8,
          ),
          const Text(
            'Your Listings',
            style: TextStyle(
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
              isYourListing: true,
            ),
          ),
        ],
      ),
    );
  }
}
