import 'package:flutter/material.dart';
import 'package:foodbridge_project/models/user.dart';

import '../widgets/review_list.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reviews',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: ReviewsList(userId: userId,),
    );
  }
}