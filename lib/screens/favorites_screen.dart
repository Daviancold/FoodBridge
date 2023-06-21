import 'package:flutter/material.dart';

class LikesScreen extends StatefulWidget {
  const LikesScreen({super.key});

  @override
  State<LikesScreen> createState() => _LikesScreenState();
}

class _LikesScreenState extends State<LikesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorites',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      // body: ListingsScreen(
      //   toList: [], //to be used as a consumer to listen for changes in likes
      //   isLikesScreen: true,
      // ),
    );
  }
}
