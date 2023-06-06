import 'package:flutter/material.dart';

class NewListingAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function() onBackArrowPressed;

  const NewListingAppBar({
    Key? key,
    required this.onBackArrowPressed,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.orange,
      title: Text('Add new listing'),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: onBackArrowPressed,
      ),
    );
  }
}
