import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../widgets/chat_widgets/chat_messages.dart';
import '../../widgets/chat_widgets/new_message.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key, required this.chatId, required this.listingId})
      : super(key: key);

  final String chatId;
  final String listingId;

  @override
  Widget build(BuildContext context) {
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

        return Scaffold(
          appBar: AppBar(
            title: const Text('Chat'),
            centerTitle: true,
            backgroundColor: Colors.orange,
          ),
          body: Column(
            children: [
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
                        width: 90,
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
                            Text(
                              'Available: ${listing['isAvailable'].toString()}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ChatMessages(
                  chatId: chatId,
                ),
              ),
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
