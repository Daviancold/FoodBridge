import 'package:flutter/material.dart';

import '../screens/listings_list_screen.dart';

class ListingsColumn extends StatelessWidget {
  final int selectedPageIndex;
  final String itemName;
  final Function addNewListing;
  final Function readListings;

  const ListingsColumn({
    super.key,
    required this.selectedPageIndex,
    required this.itemName,
    required this.addNewListing,
    required this.readListings,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        selectedPageIndex == 0
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 16,
                        ),
                        itemName == ''
                            ? const Text(
                                'All Listings',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              )
                            : Expanded(
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    'Searched for: $itemName',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        //TODO filter options
                        showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      'Modal BottomSheet',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            color: Colors.white,
                                          ),
                                    ),
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
                      icon: const Icon(Icons.filter_alt),
                      label: const Text('Filter'),
                    ),
                  ),
                ],
              )
            : Container(),
        Expanded(
          child: ListingsScreen(
            availListings: readListings(itemName),
            isYourListing: false,
          ),
        ),
      ],
    );
  }
}
