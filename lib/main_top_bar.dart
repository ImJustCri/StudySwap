import 'package:flutter/material.dart';
import 'package:studyswap/pages/notifications_page.dart';
import 'package:studyswap/misc/resources.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
        automaticallyImplyLeading: false,
        title: Image.asset(
          R.logo,
          height: 32,
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
