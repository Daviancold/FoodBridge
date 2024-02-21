import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodbridge_project/screens/chat/chatroom_screen.dart';
import 'package:foodbridge_project/widgets/notification_tile.dart';
import 'package:foodbridge_project/models/listing.dart';
import 'package:foodbridge_project/screens/listing_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final currentUserEmail = FirebaseAuth.instance.currentUser!.email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Column(
        children: [
          Flexible(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUserEmail)
                  .collection('notifications')
                  .orderBy('receivedAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No new notifications'),
                  );
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Something Went Wrong...'),
                  );
                }

                final loadedNotifications = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: loadedNotifications.length,
                  itemBuilder: (context, index) {
                    final notificationData = loadedNotifications[index].data();
                    final notificationID = loadedNotifications[index].id;
                    if (notificationData['type'] == 'chat') {
                      final listingID = notificationData['ListingId'];
                      final chatID = notificationData['chatId'];
                      final chatPartner = notificationData['chatPartnerId'];
                      final chatPartnerUserName =
                          notificationData['chatPartnerName'];
                      final message = notificationData['messageContent'];
                      final listingImage = notificationData['listingPicture'];

                      return NotificationTile(
                        titleText: 'New Message From $chatPartnerUserName',
                        subtitleText: message,
                        listingImage: listingImage,
                        notificationID: notificationID,
                        onTapFunction: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                chatId: chatID,
                                listingId: listingID,
                                chatPartner: chatPartner,
                                chatPartnerUserName: chatPartnerUserName,
                              ),
                            ),
                          );
                        },
                      );
                    } else if (notificationData['type'] == 'expiredItem') {
                      final String itemName = notificationData['itemName'];
                      final String itemExpiryDate =
                          notificationData['itemExpiryDate'];
                      final listingImage = notificationData['listingPicture'];
                      final String userEmail = notificationData['userId'];
                      final String listingID = notificationData['ListingId'];
                      dynamic isLiked;
                      return NotificationTile(
                        titleText: 'An Item You Liked Has Expired',
                        subtitleText:
                            '$itemName has expired on $itemExpiryDate',
                        listingImage: listingImage,
                        notificationID: notificationID,
                        onTapFunction: () async {
                          Listing listingData = await FirebaseFirestore.instance
                              .collection('Listings')
                              .doc(listingID)
                              .get()
                              .then((doc) => Listing.fromJson(
                                  doc.data() as Map<String, dynamic>));
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(userEmail)
                              .collection('likes')
                              .doc(listingID)
                              .get()
                              .then((snapshot) {
                            if (!snapshot.exists ||
                                snapshot.data()!['isLiked'] == false) {
                              isLiked = false;
                            } else {
                              isLiked = true;
                            }
                            setState(() {});
                          });

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListingScreen(
                                listing: listingData,
                                isYourListing: false,
                                handleLikes: () async {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(userEmail)
                                      .collection('likes')
                                      .doc(listingID)
                                      .get()
                                      .then((snapshot) {
                                    if (!snapshot.exists ||
                                        snapshot.data()!['isLiked'] == false) {
                                      FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(userEmail)
                                          .collection('likes')
                                          .doc(listingID)
                                          .set({
                                        'isLiked': true,
                                        'expiryDate': listingData.expiryDate,
                                        'isExpired': listingData.expiryDate
                                                .isAfter(DateTime.now())
                                            ? false
                                            : true,
                                      });
                                    } else {
                                      FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(userEmail)
                                          .collection('likes')
                                          .doc(listingID)
                                          .set({
                                        'isLiked': false,
                                      });
                                    }
                                  });
                                },
                                isLiked: isLiked,
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  content: SizedBox(
                    height: 16,
                    width: 16,
                    child: Center(
                      child: Text(
                        'Delete All Notification?',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  ),
                  actions: [
                    ButtonBar(
                      alignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                          },
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            _deleteNotification();
                          },
                          child: const Text('Yes'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
            child: const Text(
              'Delete All',
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}

void _deleteNotification() {
  FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.email)
      .collection('notifications')
      .get()
      .then((snapshot) {
    for (DocumentSnapshot ds in snapshot.docs) {
      ds.reference.delete();
    }
  }).catchError((error) {
    print('Failed to delete document: $error');
  });
}
