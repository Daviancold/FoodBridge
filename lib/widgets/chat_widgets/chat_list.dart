import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbridge_project/screens/chat/chatroom_screen.dart';


class AllChatList extends StatelessWidget {
  const AllChatList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .where('participants', arrayContains: user.email)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No messages found.'),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong...'),
          );
        }
        final loadedMessagesList = snapshot.data!.docs;
        return ListView.builder(
          //padding: const EdgeInsets.all(8),
          itemCount: loadedMessagesList.length,
          itemBuilder: (context, index) {
            DocumentSnapshot messageSnapshot = loadedMessagesList[index];
            Map<String, dynamic> messageData =
                messageSnapshot.data() as Map<String, dynamic>;

            // Extract the necessary data from messageData to display in the ListTile
            String listingId = messageData['listing'].trim();
            String chatId = messageData['chatId'].trim();

            List<dynamic> myArray = messageData['participants'];

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('Listings')
                  .doc(listingId)
                  .get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text("Something went wrong");
                }

                if (snapshot.hasData && !snapshot.data!.exists) {
                  print(listingId);
                  return const Text("Document does not exist");
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  final String chatPartner =
                      myArray[0] == user.email ? myArray[1] : myArray[0];
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;
                  String? imageUrl = data['image'];
                  //String? donorName = data?['userId'];
                  return Card(
                    margin: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade300,
                        radius: 20,
                        child: Text(
                          chatPartner.substring(0, 2).toUpperCase(),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      title: Text(chatPartner),
                      trailing: imageUrl != null
                          ? Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : const SizedBox(),
                      // Customize the appearance and behavior of the ListTile as needed
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ChatScreen(chatId: chatId, listingId: listingId,)),
                        );
                      },
                    ),
                  );
                }

                return const Text("loading");
              },
            );
          },
        );
      },
    );
  }
}