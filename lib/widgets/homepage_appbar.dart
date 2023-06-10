//CURRENTLY NOT USED. PUT IN TABS SCREEN FOR EASE OF TESTING

// import 'package:flutter/material.dart';

// import '../screens/chat_list_screen.dart';
// import '../screens/likes_screen.dart';
// import '../screens/notifications_screen.dart';

// class HomePageAppBar extends AppBar {
//   HomePageAppBar(BuildContext context, {super.key})
//       : super(
//           leading: IconButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const NotificationsScreen()),
//               );
//             },
//             icon: const Icon(Icons.notifications_none),
//           ),
//           backgroundColor: Colors.orange,
//           title:  SizedBox(
//             width: 200,
//             child: TextField(
//               decoration: InputDecoration(
//                 prefixIcon: const Icon(Icons.search),
//                 filled: true,
//                 fillColor: Colors.white,
//                 contentPadding:
//                     const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
//                 hintText: 'search',
//                 alignLabelWithHint: true,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//             ),
//           ),
//           centerTitle: true,
//           actions: [
//             IconButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const LikesScreen()),
//                 );
//               },
//               icon: const Icon(Icons.favorite_border),
//             ),
//             IconButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const ChatListScreen()),
//                 );
//               },
//               icon: const Icon(Icons.chat_bubble_outline),
//             ),
//           ],
//         );
// }
