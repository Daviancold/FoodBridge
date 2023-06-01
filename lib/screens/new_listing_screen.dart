import 'package:flutter/material.dart';

class NewListingScreen extends StatefulWidget {
  const NewListingScreen({super.key});

  @override
  State<NewListingScreen> createState() => _NewListingScreenState();
}

class _NewListingScreenState extends State<NewListingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('new listing'),
    );
  }
}