import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Image.asset(
        "assets/logo.png",
        height: 32,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {},
        ),
      ],
      backgroundColor: Theme.of(context).colorScheme.surface,
      toolbarHeight: 64,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
