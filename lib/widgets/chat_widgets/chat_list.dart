import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbridge_project/screens/chat/chatroom_screen.dart';
import 'package:foodbridge_project/widgets/loading.dart';

class AllChatList extends StatelessWidget {
  const AllChatList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return StreamBuilder<QuerySnapshot>(
      //Filter chats that belong to current user
      stream: FirebaseFirestore.instance
          .collection('chat')
          .where('participants', arrayContains: user.email)
          .where('hasMessages', isEqualTo: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingCircleScreen();
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
        final documents = snapshot.data!.docs;

        // Filter the documents that have the 'messages' subcollection
        final loadedMessagesList = documents
            .where((doc) =>
                doc.reference.collection('messages').snapshots().isBroadcast)
            .toList();

        return ListView.builder(
          //padding: const EdgeInsets.all(8),
          itemCount: loadedMessagesList.length,
          itemBuilder: (context, index) {
            DocumentSnapshot messageSnapshot = loadedMessagesList[index];
            Map<String, dynamic> messageData =
                messageSnapshot.data() as Map<String, dynamic>;

            // Extract the necessary IDs from messageData for referencing
            String listingId = messageData['listing'].trim();
            String chatId = messageData['chatId'].trim();

            // Extract data from messageData to display on list
            //of chat cards
            String latestMessage = '';
            List<dynamic> participantsId = messageData['participants'];
            List<dynamic> participantsUserName =
                messageData['participantsUserName'];
            DocumentReference parentDocRef = messageSnapshot.reference;
            CollectionReference subcollectionRef =
                parentDocRef.collection('messages');

            subcollectionRef
                .orderBy('createdAt', descending: true)
                .limit(1)
                .get()
                .then((subcollectionQuerySnapshot) {
              if (subcollectionQuerySnapshot.docs.isNotEmpty) {
                // Process the most recent document from the subcollection here
                DocumentSnapshot mostRecentDocument =
                    subcollectionQuerySnapshot.docs.first;
                latestMessage = mostRecentDocument['text'];
                // ...
              } else {
                print('no messages found');
              }
            });

            //Building each chat card
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
                  final String chatPartner = participantsId[0] == user.email
                      ? participantsId[1]
                      : participantsId[0];
                  final String chatPartnerUserName =
                      participantsUserName[0] == user.displayName
                          ? participantsUserName[1]
                          : participantsUserName[0];
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
                      title: Text(chatPartnerUserName, style: TextStyle(color: Colors.white),),
                      subtitle: Text(
                        latestMessage,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          imageUrl != null
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
                          IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    content: SizedBox(
                                      height: 16,
                                      width: 16,
                                      child: Center(
                                        child: Text('Delete Chat?',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .copyWith(color: Colors.black, fontSize: 16)),
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
                                              child: const Text('No')),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(ctx);
                                              _deleteChat(chatId);
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
                      // Customize the appearance and behavior of the ListTile as needed
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                    chatId: chatId,
                                    listingId: listingId,
                                    chatPartner: chatPartner,
                                    chatPartnerUserName: chatPartnerUserName,
                                  )),
                        );
                      },
                    ),
                  );
                }

                return const Center(child: CircularProgressIndicator());
              },
            );
          },
        );
      },
    );
  }
}

//delete chat document with doc id == chatId from firestore
void _deleteChat(String chatId) {
  FirebaseFirestore.instance
      .collection('chat')
      .doc(chatId)
      .delete()
      .then((value) {
    print('Document deleted successfully');
  }).catchError((error) {
    print('Failed to delete document: $error');
  });
}
