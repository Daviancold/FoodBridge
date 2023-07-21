import 'package:android_id/android_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
import 'chat/chatroom_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});
  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
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

  void setupPushNotifications() async {
    final fcm = FirebaseMessaging.instance;

    await fcm.requestPermission();

    final String? token = await fcm.getToken();

    if (token != null) {
      String userEmail = FirebaseAuth.instance.currentUser!.email.toString();
      const androidId = AndroidId();
      String? deviceId = await androidId.getId();
      FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .collection('tokens')
          .doc(deviceId)
          .get()
          .then((snapshot) {
        if (snapshot.data() == null ||
            snapshot.data()!['DeviceToken'] != token) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(userEmail)
              .collection('tokens')
              .doc(deviceId)
              .set({
            'DeviceToken': token,
          });
        }
      });
      // Configure the onMessage and onBackgroundMessage handlers
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print("Foreground Message Data: ${message.data}");
        _handleForegroundMessage(message);
      });
    }
    print(token);
  }

  void _generalMessages(RemoteMessage message) {
    if (message.data['type'] == 'chat') {
      message.data['receivedAt'] = DateTime.now();
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection('notifications')
          .doc()
          .set(message.data);
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    // Handle data payload in the foreground
    // Your custom logic here
    _generalMessages(message);
  }

  void _handleMessage(RemoteMessage message) {
    _generalMessages(message);
    if (message.data['type'] == 'chat') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            chatId: message.data['chatId'],
            listingId: message.data['ListingId'],
            chatPartner: message.data['chatPartnerId'],
            chatPartnerUserName: message.data['chatPartnerName'],
          ),
        ),
      );
    }
  }

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  @override
  void initState() {
    super.initState();
    setupPushNotifications();
    // Run code required to handle interacted messages in an async function
    // as initState() must not be async
    setupInteractedMessage();
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
                      icon: const Icon(
                        Icons.filter_alt,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Filter',
                        style: TextStyle(color: Colors.white),
                      ),
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
      activeAppBar = ProfileAppBar(context, true, 'nil', 'nil');
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
