import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodbridge_project/screens/listing_screen.dart';

import '../models/listing.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class ListingGridItem extends StatelessWidget {
  const ListingGridItem({
    super.key,
    required this.data,
    //required this.subcollectionData,
  });

  final Listing data;
  //final DocumentReference<Map<String, dynamic>> subcollectionData;

  String get formattedDate {
    return formatter.format(data.expiryDate);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ListingScreen(
              listing: data,
            ),
          ),
        );
      },
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueGrey.shade100),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 150,
              height: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  data.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                DefaultTextStyle(
                  style: TextStyle(fontSize: 10, color: Colors.black),
                  child: Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Item: ${data.itemName}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        // Text(listing.location.name),
                        Text(
                          'Expiry date: $formattedDate',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          'Address: ${data.address}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          'Donor: ${data.userId}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.favorite_border,
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
