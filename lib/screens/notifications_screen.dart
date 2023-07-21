import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodbridge_project/screens/chat/chatroom_screen.dart';

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
                    if (notificationData['type'] == 'chat') {
                      final listingID = notificationData['ListingId'];
                      final chatID = notificationData['chatId'];
                      final chatPartner = notificationData['chatPartnerId'];
                      final chatPartnerUserName =
                          notificationData['chatPartnerName'];
                      final message = notificationData['messageContent'];
                      final listingImage = notificationData['listingPicture'];
                      final notificationID = loadedNotifications[index].id;

                      return Card(
                        margin: const EdgeInsets.all(4.0),
                        child: ListTile(
                          title: Text(
                            'New Message From $chatPartnerUserName',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            message,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              listingImage != null
                                  ? Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          listingImage,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                              IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        content: SizedBox(
                                          height: 16,
                                          width: 16,
                                          child: Center(
                                            child: Text(
                                              'Delete Notification?',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(
                                                      color: Colors.black,
                                                      fontSize: 16),
                                            ),
                                          ),
                                        ),
                                        actions: [
                                          ButtonBar(
                                            alignment:
                                                MainAxisAlignment.spaceBetween,
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
                                                  _deleteNotification(
                                                      notificationID:
                                                          notificationID,
                                                      all: false);
                                                },
                                                child: const Text('Yes'),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.delete,
                                      color: Colors.white))
                            ],
                          ),
                          onTap: () {
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
                        ),
                      );
                    } else if (notificationData['type'] == 'expiredItem') {
                      // Expired item tiles
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
                            _deleteNotification(all: true);
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

void _deleteNotification({String? notificationID, required bool all}) {
  all == true
      ? FirebaseFirestore.instance
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
        })
      : FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection('notifications')
          .doc(notificationID)
          .delete()
          .catchError((error) {
          print('Failed to delete document: $error');
        });
}
