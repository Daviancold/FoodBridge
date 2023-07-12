import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AverageRatings extends StatefulWidget {
  AverageRatings({Key? key, required this.rating}) : super(key: key);

  Future<double> rating;

  @override
  State<AverageRatings> createState() => _AverageRatingsState();
}

class _AverageRatingsState extends State<AverageRatings> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<double>(
      future: widget.rating,
      builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Text(
            key: Key('Something went wrong'),
            'Something went wrong',
          );
        } else if (snapshot.hasData) {
          final double averageRating = snapshot.data!;
          print('avg rating is $averageRating');
          if (averageRating <= 0.0) {
            return const Text(
              key: Key('No reviews yet'),
              'No reviews yet',
            );
          } else {
            return Container(
              key: Key('rating'),
              child: RatingBarIndicator(
                rating: averageRating,
                itemBuilder: (BuildContext context, int index) => const Icon(
                  Icons.star,
                  color: Colors.yellow,
                ),
                itemCount: 5,
                itemSize: 20.0,
                unratedColor: Colors.grey,
                direction: Axis.horizontal,
              ),
            );
          }
        } else {
          return const Text('No reviews yet');
        }
      },
    );
  }
}
