import 'package:flutter/material.dart';

import '../screens/chat_list_screen.dart';
import '../screens/likes_screen.dart';
import '../screens/notifications_screen.dart';

class HomePageAppBar extends AppBar {
  HomePageAppBar(BuildContext context)
      : super(
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => notificationsScreen()),
              );
            },
            icon: Icon(Icons.notifications_none),
          ),
          backgroundColor: Colors.orange,
          title: Container(
            width: 200,
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                hintText: 'search',
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => likesScreen()),
                );
              },
              icon: Icon(Icons.favorite_border),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatListScreen()),
                );
              },
              icon: Icon(Icons.chat_bubble_outline),
            ),
          ],
        );
}
