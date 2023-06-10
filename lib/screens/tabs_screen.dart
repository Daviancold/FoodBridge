//import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodbridge_project/models/listing.dart';
import 'package:foodbridge_project/screens/listings_list_screen.dart';
import 'package:foodbridge_project/screens/new_listing_screen.dart';
import 'package:foodbridge_project/screens/profile_screen.dart';
import 'package:foodbridge_project/widgets/homepage_appbar.dart';
import 'package:foodbridge_project/widgets/profile_appbar.dart';
import 'chat_list_screen.dart';
import 'likes_screen.dart';
import 'notifications_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  String itemName = "";

Stream<List<Listing>> readListings(String searchQuery) {
    DateTime currentDateTime = DateTime.now();
    CollectionReference listingsRef =
        FirebaseFirestore.instance.collection('Listings');

    Query query = listingsRef
        .where("expiryDate", isGreaterThan: currentDateTime)
        .where("isAvailable", isEqualTo: true);

    if (searchQuery.isNotEmpty) {
      query = query.where("itemName", isEqualTo: searchQuery);
    }

    return query.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => Listing.fromJson(doc.data() as Map<String, dynamic>))
        .toList());
  }

  int selectedPageIndex = 0;

  void addNewListing() {
    Navigator.push<Listing>(
      context,
      MaterialPageRoute(builder: (context) => const NewListingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget activeScreen = ListingsScreen(
      availListings: readListings(itemName),
      isLikesScreenOrProfileScreen: false,
      isYourListing: false,
    );

    AppBar activeAppBar = AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const NotificationsScreen()),
          );
        },
        icon: const Icon(Icons.notifications_none),
      ),
      backgroundColor: Colors.orange,
      title: SizedBox(
        width: 200,
        child: TextField(
          onChanged: (val) {
            setState(() {
              itemName = val;
            });
          },
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
            hintText: 'Search ...',
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
              MaterialPageRoute(builder: (context) => const LikesScreen()),
            );
          },
          icon: const Icon(Icons.favorite_border),
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatListScreen()),
            );
          },
          icon: const Icon(Icons.chat_bubble_outline),
        ),
      ],
    );

    if (selectedPageIndex == 2) {
      activeScreen = const ProfileScreen();
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
