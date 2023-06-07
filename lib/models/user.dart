// TODO come up with user data model 

import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodbridge_project/models/listing.dart';

final user = FirebaseAuth.instance.currentUser!;

class userDetails {
  final String? email = user.email;
  final List<Listing> listings= [];
  final double? ratings = null;
  final List<Listing> favoriteListings = [];
  // final List<Chats> chats = [];
  // final List<Notifications> = []; 
}