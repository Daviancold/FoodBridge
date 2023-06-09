import 'package:flutter/material.dart';

class ProfileAppBar extends AppBar {
  ProfileAppBar(BuildContext context)
      : super(
          backgroundColor: Colors.orange,
          title: Text(
            'PROFILE PAGE',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 24),
          ),
          centerTitle: true,
        );
}
