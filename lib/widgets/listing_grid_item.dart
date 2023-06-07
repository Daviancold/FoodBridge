import 'package:flutter/material.dart';
import 'package:foodbridge_project/screens/listing_screen.dart';

import '../models/listing.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class ListingGridItem extends StatelessWidget {
  const ListingGridItem({super.key, required this.listing});

  final Listing listing;

  String get formattedDate {
    return formatter.format(listing.expiryDate);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ListingScreen(listing: listing)),
        );
      },
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
              width: 150,
              height: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  listing.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              listing.itemName,
              style: TextStyle(color: Colors.black),
            ),
            // Text(listing.location.name),
            Text(formattedDate),
            Text(listing.userId),
          ],
        ),
      ),
    );
  }
}
