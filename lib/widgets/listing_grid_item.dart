import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbridge_project/screens/listing_screen.dart';
import 'package:foodbridge_project/widgets/like_button.dart';
import '../models/listing.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class ListingGridItem extends StatefulWidget {
  const ListingGridItem({
    super.key,
    required this.data,
    required this.isYourListing,
    required this.isFavouritesScreen,
  });

  final Listing data;
  final bool isYourListing;
  final bool isFavouritesScreen;

  @override
  State<ListingGridItem> createState() => _ListingGridItemState();
}

class _ListingGridItemState extends State<ListingGridItem> {
  String get formattedDate {
    return formatter.format(widget.data.expiryDate);
  }

  bool isLiked = false;
  var currentUser = FirebaseAuth.instance.currentUser!.email;

  void handleLikes() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser)
        .collection('likes')
        .doc(widget.data.id)
        .get()
        .then((snapshot) {
      if (!snapshot.exists || snapshot.data()!['isLiked'] == false) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser)
            .collection('likes')
            .doc(widget.data.id)
            .set({
          'isLiked': true,
          'expiryDate': widget.data.expiryDate,
          'isExpired':
              widget.data.expiryDate.isAfter(DateTime.now()) ? false : true,
        });
      } else {
        FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser)
            .collection('likes')
            .doc(widget.data.id)
            .set({
          'isLiked': false,
        });
      }
    });
  }

  void setupLikes() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser)
        .collection('likes')
        .doc(widget.data.id)
        .get()
        .then((snapshot) {
      if (!snapshot.exists || snapshot.data()!['isLiked'] == false) {
        isLiked = false;
      } else {
        isLiked = true;
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    setupLikes();
    super.initState();
  }

  //UI layout for each grid item
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ListingScreen(
              listing: widget.data,
              isYourListing: widget.isYourListing,
              handleLikes: handleLikes,
              isLiked: isLiked,
            ),
          ),
        ).whenComplete(() {
          setupLikes();
        });
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
                      widget.data.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                widget.data.expiryDate.isAfter(DateTime.now())
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
                widget.data.isAvailable
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
            Expanded(
              child: Row(
                children: [
                  DefaultTextStyle(
                    style: const TextStyle(fontSize: 10, color: Colors.black),
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Item: ${widget.data.itemName}',
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
                            'Address: ${widget.data.address}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            'Donor: ${widget.data.userName}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                  LikeButton(
                    isLiked: isLiked,
                    onTap: () {
                      handleLikes();
                      if (!widget.isFavouritesScreen) {
                        setState(() {
                          isLiked = !isLiked;
                        });
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
