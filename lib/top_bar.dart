import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Image.asset(
          "assets/logo.png",
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            color: Theme.of(context).colorScheme.onSurface,
            onPressed: () {},
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 64,
      );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
