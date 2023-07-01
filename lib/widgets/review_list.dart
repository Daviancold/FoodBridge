import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class ReviewsList extends StatelessWidget {
  const ReviewsList({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('reviews')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No reviews found'));
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (BuildContext context, int index) {
            final reviewData = snapshot.data!.docs[index].data();

            Timestamp timestampValue = reviewData['createdAt'];

            String formattedDate =
                DateFormat('dd/MM/yyyy').format(timestampValue.toDate());

            // Customize how you want to display each review document
            return Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
              ),
              child: ListTile(
                title: Text(
                  reviewData['reviewedBy'],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 4,
                    ),
                    Text(formattedDate),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        const Text('Friendliness: '),
                        buildStarRating(reviewData['friendlinessRating']),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Ease of deal: '),
                        buildStarRating(reviewData['easeOfDealRating']),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Sincerity: '),
                        const SizedBox(
                          width: 24,
                        ),
                        buildStarRating(reviewData['sincerityRating']),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        const Text('Comments: '),
                        Text(reviewData['review']),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

Widget buildStarRating(int rating) {
  return RatingBarIndicator(
    rating: rating.toDouble(),
    itemBuilder: (BuildContext context, int index) => const Icon(
      Icons.star,
      color: Colors.yellow,
    ),
    itemCount: 5,
    itemSize: 20.0,
    unratedColor: Colors.grey,
    direction: Axis.horizontal,
  );
}
