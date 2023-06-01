//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbridge_project/screens/listings_screen.dart';
import 'package:foodbridge_project/screens/new_listing_screen.dart';
import 'package:foodbridge_project/screens/profile_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activeScreen = ListingsScreen();
    AppBar activeAppBar = AppBar(
      backgroundColor: Colors.orange,
      title: Container(
        width: 200,
        child: TextField(
          decoration: InputDecoration(
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
          onPressed: () {},
          icon: Icon(Icons.favorite_border),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.chat_bubble_outline,
          ),
        ),
      ],
    );

    if (_selectedPageIndex == 1) {
      activeScreen = NewListingScreen();
      activeAppBar = AppBar(
        backgroundColor: Colors.orange,
        title: Text('Add new listing'),
      );
    }

    if (_selectedPageIndex == 2) {
      activeScreen = ProfileScreen();
      activeAppBar = AppBar(
        backgroundColor: Colors.orange,
        title: Text('Your profile'),
      );
    }

    return Scaffold(
      appBar: activeAppBar,
      body: activeScreen,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'add'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'profile'),
        ],
      ),
    );
  }
}
