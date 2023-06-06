import 'package:flutter/material.dart';

class notificationsScreen extends StatefulWidget {
  const notificationsScreen({super.key});

  @override
  State<notificationsScreen> createState() => _notificationsScreenState();
}

class _notificationsScreenState extends State<notificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}