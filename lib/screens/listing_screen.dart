import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbridge_project/models/listing.dart';
import 'package:foodbridge_project/screens/chat/chatroom_screen.dart';
import 'package:foodbridge_project/screens/edit_listing_screen.dart';
import 'package:foodbridge_project/widgets/loading.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';

final formatter = DateFormat.yMd();

class ListingScreen extends StatefulWidget {
  const ListingScreen(
      {super.key, required this.listing, required this.isYourListing});

  final Listing listing;
  final bool isYourListing;

  @override
  State<ListingScreen> createState() => _ListingScreenState();
}

class _ListingScreenState extends State<ListingScreen> {
  bool isLoading = false;
  String get formattedDate {
    return formatter.format(widget.listing.expiryDate);
  }

  FirebaseStorage get storage {
    return FirebaseStorage.instance;
  }

  DocumentReference get docListing {
    return FirebaseFirestore.instance
        .collection('Listings')
        .doc(widget.listing.id);
  }

  //Deletes image in firebase
  Future<void> deleteFileByUrl(String fileUrl) async {
    try {
      // Extract the file name from the URL
      Uri uri = Uri.parse(fileUrl);
      String filePath = uri.path;
      String decodedFilePath = Uri.decodeComponent(filePath);
      String fileName =
          decodedFilePath.substring(decodedFilePath.lastIndexOf('/') + 1);
      print(fileName);

      // Delete the file using the file name
      await deleteFile('listingImages/$fileName');

      print('File deleted successfully');
    } catch (e) {
      print('Error deleting file: $e');
    }
  }

  Future<void> deleteFile(String filePath) async {
    Reference ref = storage.ref().child(filePath);
    await ref.delete();
  }

  //Deletes listing in firestore
  void _deleteLisiting() async {
    String fileUrl = widget.listing.image;
    await deleteFileByUrl(fileUrl);
    docListing.delete();
  }

  //updates listing isAvailable field to true in firestore
  void _markDonatedLisiting() {
    docListing.update({
      'isAvailable': false,
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    //Navigates to chatroom. Create new chatroom if it doesn't
    //yet exist between 2 specified people for a specific
    //listing. Else, go to existing chatroom.
    //If user leaves the new chatroom created
    //and there are no messages,
    //delete the chatroom doc from firestore.
    //Else, save it in firestore.
    void goToChat() async {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('chat')
              .where('participants',
                  isEqualTo: [widget.listing.userId, user.email])
              .where('listing', isEqualTo: widget.listing.id)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        print('chat found');
        setState(() {
          isLoading = true;
        });
        DocumentSnapshot<Map<String, dynamic>> chatDocSnapshot =
            querySnapshot.docs[0];
        Map<String, dynamic> chatData = chatDocSnapshot.data()!;
        String chatId = chatData['chatId'].trim();
        String listingId = chatData['listing'].trim();
        setState(() {
          isLoading = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatScreen(
                    chatId: chatId,
                    listingId: listingId,
                  )),
        );
      } else {
        print('No chat found');
        setState(() {
          isLoading = true;
        });
        Map<String, dynamic> chatData = {
          'participants': [widget.listing.userId, user.email],
          'listing': widget.listing.id,
          'chatId': '',
        };
        CollectionReference<Map<String, dynamic>> chatCollection =
            FirebaseFirestore.instance.collection('chat');

        DocumentReference<Map<String, dynamic>> newChatRef =
            await chatCollection.add(chatData);

// Retrieve the generated document ID
        String newChatId = newChatRef.id;
        await newChatRef.update({'chatId': newChatId});
        setState(() {
          isLoading = false;
        });
        await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatScreen(
                    chatId: newChatId,
                    listingId: widget.listing.id,
                  )),
        );
        bool haveMessages = await _hasMessagesSubcollection(newChatId);
        if (!haveMessages) {
          _deleteChat(newChatId);
        }
      }
    }

    //Placeholder to display on screen
    Widget content;

    //If content is loading, display a loading screen,
    //else, display the details of the listing
    isLoading
        ? content = const LoadingCircleScreen()
        : content = Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    //Listing image
                    SizedBox(
                      width: double.infinity,
                      height: 350,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          widget.listing.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        height: 80,
                        width: 128,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    //Chat button and favorites button
                    Positioned(
                      right: 16,
                      bottom: 16,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed:
                                widget.listing.userId.trim() == user.email
                                    ? null
                                    : goToChat,
                            icon: const Icon(Icons.chat_bubble_outline),
                            color: Colors.grey.shade400,
                            iconSize: 32,
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.favorite_border),
                            color: Colors.grey.shade400,
                            iconSize: 32,
                          ),
                        ],
                      ),
                    ),
                    //Visibly indicate if listing is available 
                    //for donation using a green label
                    widget.listing.isAvailable
                        ? Container()
                        : Positioned(
                            top: 0,
                            right: 0,
                            left: 0,
                            child: Container(
                              alignment: Alignment.center,
                              height: 64,
                              decoration: BoxDecoration(
                                color: Colors.green.shade400,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'MARKED AS DONATED',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 32),
                              ),
                            ),
                          ),
                    //Visibly indicate if listing has expired 
                    //using a red label
                    widget.listing.expiryDate.isAfter(DateTime.now())
                        ? Container()
                        : Positioned(
                            top: 0,
                            right: 0,
                            left: 0,
                            child: Container(
                              alignment: Alignment.center,
                              height: 64,
                              decoration: BoxDecoration(
                                color: Colors.red.shade400,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'EXPIRED',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 32),
                              ),
                            ),
                          ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                //If you are the owner of the listing,
                //you will get options to edit/update/delete
                //the listing
                widget.isYourListing
                    ? Wrap(
                        direction: Axis.horizontal,
                        children: [
                          ElevatedButton.icon(
                            onPressed: (widget.listing.isAvailable &&
                                    widget.listing.expiryDate
                                        .isAfter(DateTime.now()))
                                ? () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        content: const SizedBox(
                                          height: 16,
                                          width: 16,
                                          child: Center(
                                            child: Text('Mark as donated?'),
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(ctx);
                                              },
                                              child: const Text('No')),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(ctx);
                                              _markDonatedLisiting();
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Yes'),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                : null,
                            icon: const Icon(Icons.done),
                            label: widget.listing.isAvailable
                                ? const Text('Mark as donated')
                                : const Text('Item has been donated'),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          ElevatedButton.icon(
                            onPressed: (widget.listing.isAvailable &&
                                    widget.listing.expiryDate
                                        .isAfter(DateTime.now()))
                                ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditListingScreen(
                                                listing: widget.listing,
                                                storage: storage,
                                                docListing: docListing,
                                              )),
                                    );
                                  }
                                : null,
                            icon: const Icon(Icons.edit),
                            label: const Text('Edit listing'),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  content: const SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: Center(
                                      child: Text('Confirm deletion?'),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(ctx);
                                        },
                                        child: const Text('No')),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(ctx);
                                        _deleteLisiting();
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Yes'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: const Icon(Icons.delete),
                            label: const Text('Delete listing'),
                          ),
                        ],
                      )
                    : Container(),
                const SizedBox(
                  height: 16,
                ),
                //Display all details of listing
                //in scrollable list
                Expanded(
                  child: SingleChildScrollView(
                    child: DefaultTextStyle(
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Item: ${widget.listing.itemName}'),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                              'Main Category: ${widget.listing.mainCategory.split('.').last}'),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                              'Sub Category: ${widget.listing.subCategory.split('.').last}'),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                              'Dietary specifications: ${widget.listing.dietaryNeeds.split('.').last}'),
                          const SizedBox(
                            height: 8,
                          ),
                          Text('Expiry date: $formattedDate'),
                          const SizedBox(
                            height: 8,
                          ),
                          Text('Collection address: ${widget.listing.address}'),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                              'Available: ${widget.listing.isAvailable.toString()}'),
                          const SizedBox(
                            height: 8,
                          ),
                          Text('Donor: ${widget.listing.userName}'),
                          const SizedBox(
                            height: 8,
                          ),
                          Container(
                              padding: const EdgeInsets.all(8),
                              width: double.infinity,
                              height: 200,
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                  'Additional notes: ${widget.listing.additionalNotes}')),
                          // Add more widgets as needed
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          'LISTING: ${widget.listing.itemName.toUpperCase()}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: content,
    );
  }
}

//Checks if the chatroom has any messages
Future<bool> _hasMessagesSubcollection(String chatId) async {
  CollectionReference messagesCollection = FirebaseFirestore.instance
      .collection('chat')
      .doc(chatId)
      .collection('messages');

  QuerySnapshot querySnapshot = await messagesCollection.get();
  return querySnapshot.docs.isNotEmpty;
}

//Deletes chatroom, aka delete chat doc in firestore
void _deleteChat(String chatId) async {
  try {
    await FirebaseFirestore.instance.collection('chat').doc(chatId).delete();
    print('Document with ID $chatId deleted successfully.');
  } catch (e) {
    print('Error deleting document: $e');
  }
}
