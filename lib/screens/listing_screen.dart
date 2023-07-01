import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbridge_project/models/listing.dart';
import 'package:foodbridge_project/screens/chat/chatroom_screen.dart';
import 'package:foodbridge_project/screens/edit_listing_screen.dart';
import 'package:foodbridge_project/screens/profile_screens/others_profile_screen.dart';
import 'package:foodbridge_project/screens/report_screens/report_listing.dart';
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
  void _deleteListing() async {
    String fileUrl = widget.listing.image;
    await deleteFileByUrl(fileUrl);
    String listingId = widget.listing.id;
    deleteChatDocuments(listingId);
    docListing.delete();
  }

  void deleteChatDocuments(String listingId) async {
    // Get a reference to the 'chat' collection
    CollectionReference chatCollection =
        FirebaseFirestore.instance.collection('chat');

    // Query the collection to find the documents with the specified listingId
    QuerySnapshot snapshot =
        await chatCollection.where('listing', isEqualTo: listingId).get();

    // Loop through each document and delete it
    for (DocumentSnapshot doc in snapshot.docs) {
      // Get the document reference
      DocumentReference documentRef = doc.reference;

      // Delete the document
      await documentRef.delete();
    }
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
                    chatPartner: widget.listing.userId,
                    chatPartnerUserName: widget.listing.userName,
                  )),
        );
      } else {
        print('No chat found');
        setState(() {
          isLoading = true;
        });
        Map<String, dynamic> chatData = {
          'participants': [widget.listing.userId, user.email],
          'participantsUserName': [widget.listing.userName, user.displayName],
          'listing': widget.listing.id,
          'chatId': '',
          'hasMessages': false,
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
                    chatPartner: widget.listing.userId,
                    chatPartnerUserName: widget.listing.userName,
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
            child: SingleChildScrollView(
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
                                          content: SizedBox(
                                            height: 70,
                                            width: double.minPositive,
                                            child: Center(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'Mark as donated?',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge!
                                                        .copyWith(
                                                          color: Colors.black,
                                                        ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  const Text(
                                                    'You will not be able to undo this action once you click yes',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          actions: [
                                            ButtonBar(
                                              alignment: MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
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
                                            )
                                          ],
                                        ),
                                      );
                                    }
                                  : null,
                              icon: const Icon(Icons.done, color: Colors.white,),
                              label: widget.listing.isAvailable
                                  ? const Text('Mark as donated', style: TextStyle(color: Colors.white),)
                                  : const Text('Item has been donated', style: TextStyle(color: Colors.white),),
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
                              icon: const Icon(Icons.edit, color: Colors.white,),
                              label: const Text('Edit listing', style: TextStyle(color: Colors.white),),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    content: SizedBox(
                                      height: 70,
                                      width: double.minPositive,
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Text('Confirm deletion?',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge!
                                                    .copyWith(
                                                        color: Colors.black)),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const Text(
                                              'All chats associated with this listing will be deleted too',
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    actions: [
                                      ButtonBar(
                                        alignment: MainAxisAlignment
                                            .spaceBetween, // Align buttons to the ends
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
                                              _deleteListing();
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Yes'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: const Icon(Icons.delete, color: Colors.white,),
                              label: const Text('Delete listing', style: TextStyle(color: Colors.white),),
                            ),
                          ],
                        )
                      : Container(),
                  const SizedBox(
                    height: 16,
                  ),
                  //Display all details of listing
                  Text(
                    'Item:',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text('${widget.listing.itemName}'),
                  const SizedBox(
                    height: 8,
                  ),

                  Wrap(
                    direction: Axis.horizontal,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Main Category',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(color: Colors.white, shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(
                                      0.5), // Adjust the shadow color and opacity
                                  offset: const Offset(
                                      1, 1), // Adjust the shadow offset
                                  blurRadius:
                                      3, // Adjust the shadow blur radius
                                ),
                              ]),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              '${widget.listing.mainCategory.split('.').last}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.white, shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(
                                      0.5), // Adjust the shadow color and opacity
                                  offset: const Offset(
                                      1, 1), // Adjust the shadow offset
                                  blurRadius:
                                      3, // Adjust the shadow blur radius
                                ),
                              ]),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color:
                              Theme.of(context).colorScheme.tertiaryContainer,
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Sub Category',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(color: Colors.white, shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(
                                      0.5), // Adjust the shadow color and opacity
                                  offset: const Offset(
                                      1, 1), // Adjust the shadow offset
                                  blurRadius:
                                      3, // Adjust the shadow blur radius
                                ),
                              ]),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              widget.listing.subCategory.split('.').last,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.white, shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(
                                      0.5), // Adjust the shadow color and opacity
                                  offset: const Offset(
                                      1, 1), // Adjust the shadow offset
                                  blurRadius:
                                      3, // Adjust the shadow blur radius
                                ),
                              ]),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Dietary Specifications',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(color: Colors.white, shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(
                                      0.5), // Adjust the shadow color and opacity
                                  offset: const Offset(
                                      1, 1), // Adjust the shadow offset
                                  blurRadius:
                                      3, // Adjust the shadow blur radius
                                ),
                              ]),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              widget.listing.dietaryNeeds.split('.').last,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.white, shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(
                                      0.5), // Adjust the shadow color and opacity
                                  offset: const Offset(
                                      1, 1), // Adjust the shadow offset
                                  blurRadius:
                                      3, // Adjust the shadow blur radius
                                ),
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.person),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Donor:',
                        style: Theme.of(context).textTheme.titleMedium!,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      user.email == widget.listing.userId
                          ? Text(widget.listing.userName)
                          : GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OthersProfileScreen(
                                            userId: widget.listing.userId,
                                            userName: widget.listing.userName,
                                            userPhoto: widget.listing.userPhoto,
                                          )),
                                );
                              },
                              child: Text(
                                widget.listing.userName,
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: 16,
                                ),
                              ),
                            )
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.calendar_month_outlined),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Expiry Date:',
                        style: Theme.of(context).textTheme.titleMedium!,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(formattedDate),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      widget.listing.isAvailable
                          ? const Icon(Icons.check)
                          : const Icon(Icons.close),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Available:',
                        style: Theme.of(context).textTheme.titleMedium!,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      widget.listing.isAvailable
                          ? const Text('Yes')
                          : const Text('No'),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.location_on),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Collection/ Meetup point:',
                        style: Theme.of(context).textTheme.titleMedium!,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(widget.listing.address),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Image.network(widget.listing.addressImageUrl),
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  Container(
                      padding: const EdgeInsets.all(8),
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Additional notes:',
                            style: Theme.of(context).textTheme.titleMedium!,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(widget.listing.additionalNotes),
                        ],
                      )),
                ],
              ),
            ),
          );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Listing: ${widget.listing.itemName.toUpperCase()}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReportListing(
                      userName: widget.listing.userName,
                      userId: widget.listing.userId,
                      listingId: widget.listing.id,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.warning))
        ],
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
