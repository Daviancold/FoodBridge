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
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.black,
                  width: 2.0,
                ),
              ),
              width: 400,
              height: 400,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  listing.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(listing.itemName),
            Text(listing.mainCategory.name),
            Text(listing.subCategory.name),
            Text(listing.dietaryNeeds.name),
            Text(formattedDate),
            Text(listing.location.address),
            Text(listing.userId),
            Text(listing.additionalNotes),
            Text(listing.isExpired.toString()),
            //add more stuff later
          ],
        ),
      ),
    );
  }
}
