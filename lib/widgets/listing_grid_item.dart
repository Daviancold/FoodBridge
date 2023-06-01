import 'package:flutter/material.dart';

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
      onTap: () {},
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(16),
          // gradient:  const LinearGradient(
          //   colors: [
          //     Colors.black,
          //     Colors.grey,
          //   ],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
        ),
        child: Column(
          children: [
            Text(
              listing.imageUrl,
              style: TextStyle(color: Colors.black),
            ),
            Text(
              listing.itemName,
              style: TextStyle(color: Colors.black),
            ),
            Text(listing.location.name),
            Text(formattedDate),
          ],
        ),
      ),
    );
  }
}
