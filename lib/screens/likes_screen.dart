import 'package:flutter/material.dart';
import 'package:foodbridge_project/data/dummy_data.dart';
import 'package:foodbridge_project/screens/listings_list_screen.dart';

class likesScreen extends StatefulWidget {
  const likesScreen({super.key});

  @override
  State<likesScreen> createState() => _likesScreenState();
}

class _likesScreenState extends State<likesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your likes'),
        backgroundColor: Colors.orange,
      ),
      body: ListingsScreen(
        toList: availableListings, //to be used as a consumer to listen for changes in likes
        isLikesScreen: true,
      ),
    );
  }
}
