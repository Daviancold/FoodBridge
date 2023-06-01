import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          minimumSize: Size.fromHeight(50),
        ),
        icon: const Icon(Icons.arrow_back, size: 32),
        label: const Text(
          'Sign Out',
          style: TextStyle(fontSize: 24),
        ),
        onPressed: () => FirebaseAuth.instance.signOut(),
      ),
    );
  }
}