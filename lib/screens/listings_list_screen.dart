import 'package:flutter/material.dart';
import '../models/listing.dart';
import '../widgets/listing_grid_item.dart';

class ListingsScreen extends StatefulWidget {
  const ListingsScreen({
    super.key,
    required this.availListings,
    required this.isYourListing,
  });

  final Stream<List<Listing>> availListings;
  final bool isYourListing;

  @override
  State<ListingsScreen> createState() => _ListingsScreenState();
}

class _ListingsScreenState extends State<ListingsScreen> {
  @override
  Widget build(BuildContext context) {
    Widget buildListing(Listing listing) => ListingGridItem(
          data: listing,
          isYourListing: widget.isYourListing,
        );

    return Column(
      children: [
        StreamBuilder(
            stream: widget.availListings,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Something went wrong, ${snapshot.error}'));
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                return const Center(
                    child: Text(
                  'No available listings',
                  style: TextStyle(color: Colors.black),
                ));
              } else if (snapshot.hasData) {
                final allListings = snapshot.data!;
                
                return Expanded(
                  child: GridView(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    children: allListings
                        .map<Widget>((listings) => buildListing(listings))
                        .toList(),
                  ),
                );
              } else {
                return const Text('Nothing to show');
              }
            })
      ],
    );
  }
}
