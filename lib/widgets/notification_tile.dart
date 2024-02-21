import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
    required this.titleText,
    required this.subtitleText,
    required this.listingImage,
    required this.notificationID,
    required this.onTapFunction,
  });

  final dynamic titleText;
  final dynamic subtitleText;
  final dynamic listingImage;
  final dynamic notificationID;
  final Function() onTapFunction;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(4.0),
      child: ListTile(
        title: Text(
          titleText,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          subtitleText,
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
                                _deleteNotification(notificationID: notificationID);
                              },
                              child: const Text('Yes'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.delete, color: Colors.white))
          ],
        ),
        onTap: onTapFunction,
      ),
    );
  }
}

void _deleteNotification({required String notificationID}) {
  FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.email)
      .collection('notifications')
      .doc(notificationID)
      .delete()
      .catchError((error) {
      print('Failed to delete document: $error');
    });
}
