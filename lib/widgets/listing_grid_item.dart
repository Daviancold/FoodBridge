import 'package:flutter/material.dart';
import 'package:foodbridge_project/screens/listing_screen.dart';
import '../models/listing.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class ListingGridItem extends StatelessWidget {
  const ListingGridItem({
    super.key,
    required this.data,
    required this.isYourListing,
  });

  final Listing data;
  final bool isYourListing;

  String get formattedDate {
    return formatter.format(data.expiryDate);
  }

  //UI layout for each grid item
  //that is used for grid view
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ListingScreen(
              listing: data,
              isYourListing: isYourListing,
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
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
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
                data.expiryDate.isAfter(DateTime.now())
                    ? Container()
                    : Positioned(
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: Container(
                          alignment: Alignment.center,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.red.shade400,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'EXPIRED',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 12),
                          ),
                        ),
                      ),
                data.isAvailable
                    ? Container()
                    : Positioned(
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: Container(
                          alignment: Alignment.center,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.green.shade400,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'MARKED AS DONATED',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 12),
                          ),
                        ),
                      ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                DefaultTextStyle(
                  style: const TextStyle(fontSize: 10, color: Colors.black),
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
                          'Donor: ${data.userName}',
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
