import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbridge_project/screens/ratings_screen/rate_donor_screen.dart';
import 'package:foodbridge_project/screens/ratings_screen/rate_recipient_screen.dart';
import 'package:intl/intl.dart';
import '../../widgets/chat_widgets/chat_messages.dart';
import '../../widgets/chat_widgets/new_message.dart';
import '../report_screens/report_listing.dart';
import '../report_screens/report_user.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key? key,
    required this.chatId,
    required this.listingId,
    required this.chatPartner,
    required this.chatPartnerUserName,
  }) : super(key: key);

  final String chatId;
  final String listingId;
  final String chatPartner;
  final String chatPartnerUserName;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    //Retrieves information about listing
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection('Listings')
          .doc(widget.listingId)
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
        bool isOffered =
            listing['offeredDonationTo']?.contains(widget.chatPartner) ?? false;
        bool offeredTo =
            listing['offeredDonationTo']?.contains(user!.email) ?? false;
        bool canReviewRecipient = listing['donatedTo'] == (widget.chatPartner);
        bool canReviewDonor = listing['donatedTo'] == (user!.email);
        bool isDonorReviewed = listing['isDonorReviewed'];
        bool isRecipientReviewed = listing['isRecipientReviewed'];
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
                                userName: widget.chatPartnerUserName,
                                userId: widget.chatPartner,
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
                  child: Column(
                    children: [
                      Row(
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
                                    color: Colors.white
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Main category: ${listing['mainCategory'].split('.').last}',
                                  style: const TextStyle(fontSize: 12, color: Colors.white),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Subcategory: ${listing['subCategory'].split('.').last}',
                                  style: const TextStyle(fontSize: 12, color: Colors.white),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Location: ${listing['address'].split('.').last}',
                                  style: const TextStyle(fontSize: 12, color: Colors.white),
                                  overflow: TextOverflow.visible,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Text(
                                      'Available:',
                                      style: TextStyle(fontSize: 12, color: Colors.white),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      listing['isAvailable'] ? 'Yes' : 'No',
                                      style: const TextStyle(fontSize: 12, color: Colors.white),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Expiry Date: ${DateFormat('MM/dd/yyyy').format(expiryDate)}',
                                  style: const TextStyle(fontSize: 12, color: Colors.white),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Donor: ${listing['userName'].toString()}',
                                  style: const TextStyle(fontSize: 12, color: Colors.white),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          user.email == listing['userId']
                              ? ElevatedButton.icon(
                                  onPressed: (isOffered || (listing['isAvailable'] == false))
                                      ? null
                                      : () {
                                          // Add an extra field of type array and add a string to it
                                          List<String> offeredDonationTo =
                                              List.from(listing[
                                                      'offeredDonationTo'] ??
                                                  []);
                                          offeredDonationTo
                                              .add(widget.chatPartner);

                                          // Update the 'listing' map with the modified array
                                          Map<String, dynamic> updatedOffers = {
                                            ...listing,
                                            'offeredDonationTo':
                                                offeredDonationTo,
                                          };

                                          // Update the Firestore document with the modified 'listing'
                                          FirebaseFirestore.instance
                                              .collection('Listings')
                                              .doc(widget.listingId)
                                              .update(updatedOffers)
                                              .then((_) {
                                            print(
                                                'Array field updated successfully');
                                          }).catchError((error) {
                                            print(
                                                'Error updating array field: $error');
                                          });
                                          setState(() {
                                            //refresh
                                          });
                                        },
                                  icon: const Icon(Icons.done, color: Colors.white),
                                  label: const Text('Offer donation',style: TextStyle(color: Colors.white),),
                                )
                              : ElevatedButton.icon(
                                  onPressed:
                                      (offeredTo && listing['isAvailable'])
                                          ? () {
                                              FirebaseFirestore.instance
                                                  .collection('Listings')
                                                  .doc(widget.listingId)
                                                  .update({
                                                'isAvailable': false,
                                                'donatedTo': user.email,
                                              });
                                              setState(() {
                                                //refresh
                                              });
                                            }
                                          : null,
                                  icon: const Icon(Icons.done, color: Colors.white),
                                  label: const Text('Accept donation', style: TextStyle(color: Colors.white),),
                                ),
                          const Spacer(),
                          user.email == listing['userId']
                              ? ElevatedButton.icon(
                                  onPressed: (canReviewRecipient &&
                                          (isRecipientReviewed == false))
                                      ? () async {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RateRecipientScreen(
                                                      userId:
                                                          widget.chatPartner,
                                                      userName: widget
                                                          .chatPartnerUserName,
                                                      listingId:
                                                          widget.listingId,
                                                    )),
                                          );
                                          setState(() {
                                            //refresh
                                          });
                                        }
                                      : null,
                                  icon: const Icon(Icons.rate_review, color: Colors.white),
                                  label: const Text('Give ratings', style: TextStyle(color: Colors.white),),
                                )
                              : ElevatedButton.icon(
                                  onPressed: (canReviewDonor &&
                                          (isDonorReviewed == false))
                                      ? () async {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RateDonorScreen(
                                                      userId:
                                                          widget.chatPartner,
                                                      userName: widget
                                                          .chatPartnerUserName,
                                                      listingId:
                                                          widget.listingId,
                                                    )),
                                          );
                                          setState(() {
                                            //refresh
                                          });
                                        }
                                      : null,
                                  icon: const Icon(Icons.rate_review, color: Colors.white),
                                  label: const Text('Give ratings', style: TextStyle(color: Colors.white),),
                                )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              //All text messages/ text bubbles
              Expanded(
                child: ChatMessages(
                  chatId: widget.chatId,
                ),
              ),
              //text field to key in new
              //message or text
              NewMessage(
                chatId: widget.chatId,
              ),
            ],
          ),
        );
      },
    );
  }
}
