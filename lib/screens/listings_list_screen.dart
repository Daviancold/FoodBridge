import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/listing.dart';
import '../widgets/listing_grid_item.dart';

class ListingsScreen extends StatefulWidget {
  const ListingsScreen(
      {super.key,
      required this.availListings,
      required this.isLikesScreenOrProfileScreen,
      required this.isYourListing,
      });

  final Stream<List<Listing>> availListings;
  final bool isLikesScreenOrProfileScreen;
  final bool isYourListing;

  @override
  State<ListingsScreen> createState() => _ListingsScreenState();
}

class _ListingsScreenState extends State<ListingsScreen> {
  @override
  Widget build(BuildContext context) {
    Widget buildListing(Listing listing) => ListingGridItem(data: listing, isYourListing: widget.isYourListing,);

    return Column(
      children: [
        if (!widget.isLikesScreenOrProfileScreen)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 16,
              ),
              Text(
                'All Listings',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ), //TODO make it dynamic to display filtered results
              Spacer(),
              Container(
                margin: EdgeInsets.all(8),
                child: ElevatedButton.icon(
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: MediaQuery.of(context).size.height,
                          color: Colors.orange,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                const Text('Modal BottomSheet'),
                                ElevatedButton(
                                  child: const Text('Close BottomSheet'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.filter_alt),
                  label: Text('Filter'),
                ),
              ),
            ],
          ),
        StreamBuilder(
            stream: widget.availListings,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
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
                // final filteredListings = allListings.where("isAvailable", isEqualto : true);

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
                return Text('Nothing to show');
              }
            })
      ],
    );
  }
}
