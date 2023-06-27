import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AverageRatings extends StatefulWidget {
  const AverageRatings({super.key, required this.userId});

  final String userId;
  @override
  State<AverageRatings> createState() => _AverageRatingsState();
}

class _AverageRatingsState extends State<AverageRatings> {

  Future<String> calculateAverageRating() async {
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
        final String formattedRating = averageRating.toStringAsFixed(2);
        return '$formattedRating / 5';
      }
    }

    return 'No reviews yet';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: calculateAverageRating(),
      initialData: 'Loading',
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Text(
          snapshot.data ?? 'No reviews yet',
        );
      },
    );
  }
}
