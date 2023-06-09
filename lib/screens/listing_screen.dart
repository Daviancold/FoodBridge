import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodbridge_project/models/listing.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class ListingScreen extends StatelessWidget {
  const ListingScreen(
      {super.key, required this.listing, required this.isYourListing});

  final Listing listing;
  final bool isYourListing;

  String get formattedDate {
    return formatter.format(listing.expiryDate);
  }

  DocumentReference get docListing {
    return FirebaseFirestore.instance.collection('Listings').doc(listing.id);
  }

  void _deleteLisiting() {
    docListing.delete();
  }

  void _markDonatedLisiting() {
    docListing.update({
      'isAvailable': false,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          'LISTING: ${listing.itemName.toUpperCase()}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 350,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      listing.image,
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
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.chat_bubble_outline),
                        color: Colors.grey.shade400,
                        iconSize: 32,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.favorite_border),
                        color: Colors.grey.shade400,
                        iconSize: 32,
                      ),
                    ],
                  ),
                ),
                listing.isAvailable
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
                          child: Text(
                            'MARKED AS DONATED',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 32),
                          ),
                        ),
                      ),
                listing.expiryDate.isAfter(DateTime.now())
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
                          child: Text(
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
            isYourListing
                ? Wrap(
                    direction: Axis.horizontal,
                    children: [
                      ElevatedButton.icon(
                        onPressed: (listing.isAvailable &&
                                listing.expiryDate.isAfter(DateTime.now()))
                            ? () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    content: Container(
                                      height: 16,
                                      width: 16,
                                      child: Center(
                                        child: const Text('Mark as donated?'),
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
                        icon: Icon(Icons.done),
                        label: listing.isAvailable
                            ? Text('Mark as donated')
                            : Text('Item has been donated'),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.edit),
                        label: Text('Edit listing'),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              content: Container(
                                height: 16,
                                width: 16,
                                child: Center(
                                  child: const Text('Confirm deletion?'),
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
                        icon: Icon(Icons.delete),
                        label: Text('Delete listing'),
                      ),
                    ],
                  )
                : Container(),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: DefaultTextStyle(
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Item: ${listing.itemName}'),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                          'Main Category: ${listing.mainCategory.split('.').last}'),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                          'Sub Category: ${listing.subCategory.split('.').last}'),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                          'Dietary specifications: ${listing.dietaryNeeds.split('.').last}'),
                      const SizedBox(
                        height: 8,
                      ),
                      Text('Expiry date: $formattedDate'),
                      const SizedBox(
                        height: 8,
                      ),
                      Text('Collection address: ${listing.address}'),
                      const SizedBox(
                        height: 8,
                      ),
                      Text('Available: ${listing.isAvailable.toString()}'),
                      const SizedBox(
                        height: 8,
                      ),
                      Text('Donor: ${listing.userId}'),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                          padding: EdgeInsets.all(8),
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                              'Additional notes: ${listing.additionalNotes}')),
                      // Add more widgets as needed
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
