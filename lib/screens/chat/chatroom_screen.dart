import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../widgets/chat_widgets/chat_messages.dart';
import '../../widgets/chat_widgets/new_message.dart';
import '../report_screens/report_listing.dart';
import '../report_screens/report_user.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen(
      {Key? key,
      required this.chatId,
      required this.listingId,
      required this.chatPartner,
      required this.chatPartnerUserName,
      })
      : super(key: key);

  final String chatId;
  final String listingId;
  final String chatPartner;
  final String chatPartnerUserName;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    //Retrieves information about listing
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection('Listings')
          .doc(listingId)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.data() == null) {
          return const Center(child: Text('Data not available'));
        }

        final listing = snapshot.data!.data()!;
        Timestamp expiryTimestamp = listing['expiryDate'];
        DateTime expiryDate = expiryTimestamp.toDate();

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Chat',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            actions: user!.email == listing['userId']
                ? [
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        // Handle option selection
                        if (value == 'option1') {
                          // Handle option 1
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReportUser(
                                userName: chatPartnerUserName,
                                userId: chatPartner,
                              ),
                            ),
                          );
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem<String>(
                          value: 'option1',
                          child: Text('Report User'),
                        ),
                      ],
                    ),
                  ]
                : [
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        // Handle option selection
                        if (value == 'option1') {
                          // Handle option 1
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReportListing(
                                userName: listing['userName'],
                                userId: listing['userId'],
                                listingId: listing['id'],
                              ),
                            ),
                          );
                        } else if (value == 'option2') {
                          // Handle option 2
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReportUser(
                                userName: listing['userName'],
                                userId: listing['userId'],
                              ),
                            ),
                          );
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem<String>(
                          value: 'option1',
                          child: Text('Report Listing'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'option2',
                          child: Text('Report User'),
                        ),
                      ],
                    ),
                  ],
          ),
          body: Column(
            children: [
              //Brief summary of listing details
              //displayed at the top of chatroom
              Card(
                margin: const EdgeInsets.all(16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(listing['image']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              listing['itemName'],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Main category: ${listing['mainCategory'].split('.').last}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Subcategory: ${listing['subCategory'].split('.').last}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Location: ${listing['address'].split('.').last}',
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.visible,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Text(
                                  'Available:',
                                  style: TextStyle(fontSize: 12),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  listing['isAvailable'] ? 'Yes' : 'No',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Expiry Date: ${DateFormat('MM/dd/yyyy').format(expiryDate)}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Donor: ${listing['userName'].toString()}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              //All text messages/ text bubbles
              Expanded(
                child: ChatMessages(
                  chatId: chatId,
                ),
              ),
              //text field to key in new
              //message or text
              NewMessage(
                chatId: chatId,
              ),
            ],
          ),
        );
      },
    );
  }
}
