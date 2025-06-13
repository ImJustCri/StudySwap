import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AppBar(
        title: Image.asset(
          "assets/logo.png",
          height: 32,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            color: Theme.of(context).colorScheme.onSurface,
            onPressed: () {},
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.surface,
        toolbarHeight: 64,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
