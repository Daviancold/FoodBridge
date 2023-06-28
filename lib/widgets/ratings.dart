import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AverageRatings extends StatefulWidget {
  const AverageRatings({Key? key, required this.userId}) : super(key: key);

  final String userId;

  @override
  State<AverageRatings> createState() => _AverageRatingsState();
}

class _AverageRatingsState extends State<AverageRatings> {
  Future<double> calculateAverageRating() async {
    final DocumentReference userDoc =
        FirebaseFirestore.instance.collection('users').doc(widget.userId);

    final CollectionReference reviewsCollection = userDoc.collection('reviews');

    final QuerySnapshot reviewsSnapshot = await reviewsCollection.get();

    if (reviewsSnapshot.docs.isNotEmpty) {
      double totalRating = 0.0;
      int reviewCount = 0;

      for (final QueryDocumentSnapshot reviewDoc in reviewsSnapshot.docs) {
        final double avgRating = reviewDoc['avgRating']?.toDouble() ?? 0.0;
        totalRating += avgRating;
        reviewCount++;
      }

      if (reviewCount > 0) {
        final double averageRating = totalRating / reviewCount;
        return averageRating;
      }
    }

    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<double>(
      future: calculateAverageRating(),
      builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          final double averageRating = snapshot.data!;
          return RatingBarIndicator(
            rating: averageRating,
            itemBuilder: (BuildContext context, int index) => const Icon(
              Icons.star,
              color: Colors.yellow,
            ),
            itemCount: 5,
            itemSize: 20.0,
            unratedColor: Colors.grey,
            direction: Axis.horizontal,
          );
        } else {
          return const Text('No reviews yet');
        }
      },
    );
  }
}
