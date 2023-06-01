import 'package:flutter/material.dart';
import 'package:foodbridge_project/data/dummy_data.dart';

import '../widgets/listing_grid_item.dart';

class ListingsScreen extends StatefulWidget {
  const ListingsScreen({super.key});

  @override
  State<ListingsScreen> createState() => _ListingsScreenState();
}

class _ListingsScreenState extends State<ListingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              alignment: Alignment.centerRight,
              onPressed: () {
                // Filter icon button onPressed action
              },
              icon: Icon(Icons.filter_alt),
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
              for (final listing in availableListings)
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
