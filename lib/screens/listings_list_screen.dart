import 'package:flutter/material.dart';

import '../models/listing.dart';
import '../widgets/listing_grid_item.dart';

class ListingsScreen extends StatefulWidget {
  const ListingsScreen(
      {super.key, required this.toList, required this.isLikesScreen});

  final List<Listing> toList;
  final bool isLikesScreen;

  @override
  State<ListingsScreen> createState() => _ListingsScreenState();
}

class _ListingsScreenState extends State<ListingsScreen> {
  @override
  Widget build(BuildContext context) {
    if (widget.toList.isEmpty) {
      return Center(
        child: Text('Nothing to show'),
      );
    }
    return Column(
      children: [
        if (!widget.isLikesScreen)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
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
        Expanded(
          child: GridView(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            children: [
              for (final listing in widget.toList)
                ListingGridItem(
                  listing: listing,
                )
            ],
          ),
        ),
      ],
    );
  }
}
