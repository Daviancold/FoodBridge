import 'package:flutter/material.dart';

class LoadingCircleScreen extends StatelessWidget {
  const LoadingCircleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
