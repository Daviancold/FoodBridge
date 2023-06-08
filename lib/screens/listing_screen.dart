import 'package:flutter/material.dart';
import 'package:foodbridge_project/models/listing.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class ListingScreen extends StatelessWidget {
  const ListingScreen({super.key, required this.listing});

  final Listing listing;

  String get formattedDate {
    return formatter.format(listing.expiryDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Listing: ${listing.itemName}'),
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
              ],
            ),
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
                      Text('Expired: ${listing.isExpired.toString()}'),
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
