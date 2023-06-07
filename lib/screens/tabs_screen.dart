//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbridge_project/data/dummy_data.dart';
import 'package:foodbridge_project/models/listing.dart';
import 'package:foodbridge_project/screens/listings_list_screen.dart';
import 'package:foodbridge_project/screens/new_listing_screen.dart';
import 'package:foodbridge_project/screens/profile_screen.dart';
import 'package:foodbridge_project/widgets/homepage_appbar.dart';
import 'package:foodbridge_project/widgets/profile_appbar.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int selectedPageIndex = 0;
  final List<Listing> _listingItems = [];
  //bool hideNavigationBar = false;

  void addNewListing() async {
    final newListing = await Navigator.push<Listing>(
      context,
      MaterialPageRoute(builder: (context) => NewListingScreen()),
    );
    if (newListing == null) {
      return;
    }
    setState(() {
      _listingItems.add(newListing);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activeScreen = ListingsScreen(
      toList: _listingItems,
      isLikesScreen: false,
    );
    AppBar activeAppBar = HomePageAppBar(context);

    if (_listingItems.isEmpty) {
      print('empty list');
    }

    if (selectedPageIndex == 2) {
      activeScreen = ProfileScreen();
      activeAppBar = ProfileAppBar(context);
    }

    return Scaffold(
      appBar: activeAppBar,
      body: activeScreen,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          if (index == 1) {
            addNewListing();
          } else {
            setState(() {
              selectedPageIndex = index;
            });
          }
        },
        selectedIndex: selectedPageIndex,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_box),
            label: 'Add',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
