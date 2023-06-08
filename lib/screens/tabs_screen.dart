//import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodbridge_project/models/listing.dart';
import 'package:foodbridge_project/screens/listings_list_screen.dart';
import 'package:foodbridge_project/screens/new_listing_screen.dart';
import 'package:foodbridge_project/screens/profile_screen.dart';
import 'package:foodbridge_project/screens/testing_firebase.dart';
import 'package:foodbridge_project/widgets/homepage_appbar.dart';
import 'package:foodbridge_project/widgets/profile_appbar.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  Stream<List<Listing>> readListings() => FirebaseFirestore.instance
        .collection('Listings')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Listing.fromJson(doc.data())).toList());
  
  int selectedPageIndex = 0;

  void addNewListing() {
    Navigator.push<Listing>(
      context,
      MaterialPageRoute(builder: (context) => NewListingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget activeScreen = ListingsScreen(
      availListings: readListings(),
      isLikesScreen: false,
    );
    AppBar activeAppBar = HomePageAppBar(context);

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
