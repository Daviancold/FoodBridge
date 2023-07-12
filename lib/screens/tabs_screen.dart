import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodbridge_project/models/listing.dart';
import 'package:foodbridge_project/screens/new_listing_screen.dart';
import 'package:foodbridge_project/screens/profile_screens/own_profile_screen.dart';
import 'package:foodbridge_project/widgets/filter_mapping.dart';
import 'package:foodbridge_project/widgets/profile_appbar.dart';
import 'listings_list_screen.dart';
import 'chat/chat_list_screen.dart';
import 'favorites_screen.dart';
import 'notifications_screen.dart';
import '../widgets/filter.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});
  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  void refreshScreen() {
    setState(() {});
  }

  String itemName = "";
  int selectedPageIndex = 0;
  List<String> editedFoodTypes = [];
  String editedDietaryNeeds = '';
  //Get snapshot from Firestore collection "Listings".
  //Filters documents by expiration date and availability, converts snapshots to lists,
  //then displays it on screen.
  //If user has searched for something, it also filters out items that have an exact
  //match for item name.
  //Get snapshot from Firestore collection "Listings".
  //Filters documents by expiration date and availability, converts snapshots to lists,
  //then displays it on screen.
  //If user has searched for something, it also filters out items that have an exact
  //match for item name.
  Stream<List<Listing>> readListings(String searchQuery) {
    DateTime currentDateTime = DateTime.now();
    CollectionReference listingsRef =
        FirebaseFirestore.instance.collection('Listings');

    Query query = listingsRef
        .where("expiryDate", isGreaterThan: currentDateTime)
        .where("isAvailable", isEqualTo: true);
    //.where("subCategory", whereIn: selectedOptions);

    if (searchQuery.isNotEmpty) {
      String searchResult = searchQuery.trim().toUpperCase();
      query = query.where("itemName", isEqualTo: searchResult);
    }

    if (selectedFoodTypes.isNotEmpty) {
      editedFoodTypes = [];
      for (int i = 0; i < selectedFoodTypes.length; i += 1) {
        editedFoodTypes.add(filterMap[selectedFoodTypes[i]]!);
      }
      query = query.where('subCategory', whereIn: editedFoodTypes);
    }

    if (selectedDietaryNeeds.isNotEmpty) {
      editedDietaryNeeds = '';
      for (int i = 0; i < selectedDietaryNeeds.length; i += 1) {
        editedDietaryNeeds = filterMap[selectedDietaryNeeds[i]]!;
      }
      query = query.where('dietaryNeeds', isEqualTo: editedDietaryNeeds);
    }

    return query.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => Listing.fromJson(doc.data() as Map<String, dynamic>))
        .toList());
  }

  //push 'add new listing screen' on top
  void addNewListing() {
    Navigator.push<Listing>(
      context,
      MaterialPageRoute(builder: (context) => const NewListingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget activeScreen = Column(
      children: [
        selectedPageIndex == 0
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 16,
                        ),
                        itemName == ''
                            ? const Text(
                                'All Listings',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              )
                            : Expanded(
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    'Searched for: $itemName',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return const FilterWidget();
                          },
                        ).whenComplete(() {
                          setState(() {
                            // refresh screen
                          });
                        });
                      },
                      icon: const Icon(Icons.filter_alt, color: Colors.white,),
                      label: const Text('Filter', style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ],
              )
            : Container(),
        Expanded(
          child: ListingsScreen(
            availListings: readListings(itemName),
            isYourListing: false,
            isFavouritesScreen: false,
          ),
        ),
      ],
    );

    //By default, active app bar is the app bar for home page
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
            ).whenComplete(() => setState(() {}));
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

    //checks the page selected in navigation bar
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