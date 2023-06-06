import 'package:flutter/material.dart';
import 'package:foodbridge_project/models/listing.dart';

class ListingScreen extends StatelessWidget {
  const ListingScreen({super.key, required this.listing});

  final Listing listing;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listing: ${listing.itemName}'),
      ),
      body: Column(children: [
        Text(listing.imageUrl),
        Text(listing.itemName),
        Text(listing.dietaryNeeds.name),
        //add more stuff later
      ],),
    );
  }
}