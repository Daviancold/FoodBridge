import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbridge_project/screens/help_screen.dart';

import '../screens/report_screens/report_user.dart';

class ProfileAppBar extends AppBar {
  ProfileAppBar(BuildContext context, bool isOwnProfile, String? userName, String? userId, {super.key})
      : super(
            title: Text(
              'Profile Page',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            centerTitle: true,
            actions: isOwnProfile
                ? [
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        // Handle option selection
                        if (value == 'option1') {
                          // Handle option 1
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HelpScreen(),
                            ),
                          );
                        } else if (value == 'option2') {
                          // Handle option 2
                          FirebaseAuth.instance.signOut();
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem<String>(
                          value: 'option1',
                          child: Text('Guide'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'option2',
                          child: Text('Sign Out'),
                        ),
                      ],
                    ),
                  ]
                : [
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        // Handle option selection
                        if (value == 'option1') {
                          // Handle option 1
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HelpScreen(),
                            ),
                          );
                        } else if (value == 'option2') {
                          // Handle option 2
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReportUser(
                                userName: userName!,
                                userId: userId!,
                              ),
                            ),
                          );
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem<String>(
                          value: 'option1',
                          child: Text('Guide'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'option2',
                          child: Text('Report User'),
                        ),
                      ],
                    ),
                  ]);
}
