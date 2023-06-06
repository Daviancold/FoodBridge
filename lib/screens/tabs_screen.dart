//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbridge_project/data/dummy_data.dart';
import 'package:foodbridge_project/screens/listings_list_screen.dart';
import 'package:foodbridge_project/screens/new_listing_screen.dart';
import 'package:foodbridge_project/screens/profile_screen.dart';
import 'package:foodbridge_project/widgets/homepage_appbar.dart';
import 'package:foodbridge_project/widgets/new_listing_appbar.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int selectedPageIndex = 0;
  bool hideNavigationBar = false;

  @override
  Widget build(BuildContext context) {
    Widget activeScreen = ListingsScreen(toList: availableListings, isLikesScreen: false,);
    PreferredSizeWidget activeAppBar = HomePageAppBar(context);

    void navigateToScreen(int index) {
      setState(() {
        selectedPageIndex = index;
        hideNavigationBar = false;
      });
    }

    if (selectedPageIndex == 1) {
      hideNavigationBar = true;
      activeScreen = NewListingScreen();
      activeAppBar = NewListingAppBar(
        onBackArrowPressed: () {
          navigateToScreen(0);
        },
      );
    }

    if (selectedPageIndex == 2) {
      activeScreen = ProfileScreen();
      activeAppBar = AppBar(
        backgroundColor: Colors.orange,
        title: Text('Your profile'),
      );
    }

    return Scaffold(
      appBar: activeAppBar,
      body: activeScreen,
      bottomNavigationBar: hideNavigationBar
          ? null
          : NavigationBar(
              onDestinationSelected: (int index) {
                setState(() {
                  selectedPageIndex = index;
                });
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
