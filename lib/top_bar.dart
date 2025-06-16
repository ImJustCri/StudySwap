import 'package:flutter/material.dart';
import 'package:studyswap/pages/notifications_page.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
        title: Image.asset(
          "assets/logo.png",
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            color: theme.colorScheme.onSurface,
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
        ],
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 64,
      );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
