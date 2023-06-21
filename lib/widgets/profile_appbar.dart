import 'package:flutter/material.dart';

class ProfileAppBar extends AppBar {
  ProfileAppBar(BuildContext context, {super.key})
      : super(
          title: Text(
            'Profile Page',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          centerTitle: true,
        );
}
