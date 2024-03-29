import 'package:flutter/material.dart';
import '../models/listing.dart';
import '../widgets/listing_grid_item.dart';

class ListingsScreen extends StatefulWidget {
  const ListingsScreen({
    super.key,
    required this.availListings,
    required this.isYourListing,
    required this.isFavouritesScreen,
  });

  final Stream<List<Listing>> availListings;
  final bool isYourListing;
  final bool isFavouritesScreen;

  @override
  State<ListingsScreen> createState() => _ListingsScreenState();
}

class _ListingsScreenState extends State<ListingsScreen> {
  @override
  Widget build(BuildContext context) {
    Widget buildListing(Listing listing) => ListingGridItem(
          data: listing,
          isYourListing: widget.isYourListing,
          isFavouritesScreen: widget.isFavouritesScreen,

        );

    return Column(
      children: [
        StreamBuilder(
            stream: widget.availListings,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return Center(
                    child: Text(
                  'Something went wrong, ${snapshot.error}',
                  key: const Key('error message'),
                ));
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                return const Expanded(
                  child: Center(
                    child: Text(
                      'No available listings',
                      style: TextStyle(color: Colors.black),
                      key: Key('No available listings text'),
                    ),
                  ),
                );
              } else if (snapshot.hasData) {
                final allListings = snapshot.data!;

                return Expanded(
                  child: GridView(
                    key: const Key('Gridview'),
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
