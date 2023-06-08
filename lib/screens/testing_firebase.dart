// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';

// class User {
//   User({
//     this.id = '',
//     required this.name,
//     required this.age,
//     required this.birthday,
//   });

//   String id;
//   final String name;
//   final int age;
//   final DateTime birthday;

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'name': name,
//         'age': age,
//         'birthday': birthday,
//       };

//   static User fromJson(Map<String, dynamic> json) => User(
//         id: json['id'],
//         name: json['name'],
//         age: json['age'],
//         birthday: (json['birthday'] as Timestamp).toDate(),
//       );
// }

// class TestingPage extends StatefulWidget {
//   const TestingPage({super.key});

//   @override
//   State<TestingPage> createState() => _TestingPageState();
// }

// class _TestingPageState extends State<TestingPage> {
//   final controller = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     // Widget buildUser(User user) => ListTile(
//     //       leading: CircleAvatar(child: Text('${user.age}')),
//     //       title: Text(user.name),
//     //       subtitle: Text(user.birthday.toIso8601String()),
//     //     );

//     // Stream<List<User>> readUsers() => FirebaseFirestore.instance
//     //     .collection('testing')
//     //     .snapshots()
//     //     .map((snapshot) =>
//     //         snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());

//     Future createUser({required String name}) async {
//       final docUser = FirebaseFirestore.instance.collection('testing').doc();

//       final user = User(
//         id: docUser.id,
//         name: name,
//         age: 21,
//         birthday: DateTime.now(),
//       );

//       final json = user.toJson();
//       await docUser.set(json);
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: TextField(
//           controller: controller,
//         ),
//         actions: [
//           IconButton(
//             onPressed: () {
//               final name = controller.text;
//               createUser(name: name);
//             },
//             icon: Icon(Icons.add),
//           )
//         ],
//       ),
//       body: StreamBuilder<List<User>>(
//         stream: readUsers(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Text('${snapshot.error}');
//           } else if (snapshot.hasData) {
//             final users = snapshot.data!;
//             return ListView(
//               children: users.map(buildUser).toList(),
//             );
//           } else {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
