import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studyswap/coins_page.dart';
import 'package:studyswap/misc/resources.dart';
import 'package:studyswap/providers/data_provider.dart';

class TopBar extends ConsumerWidget implements PreferredSizeWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dataAsync = ref.watch(dataProvider);

    Widget coinsButton(String coins) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(64.0),
          color: theme.colorScheme.onSurface,
        ),
        child: TextButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CoinsPage(coins)),
            );
          },
          icon: Icon(
            Icons.monetization_on,
            color: theme.colorScheme.surface,
            size: 24,
          ),
          label: Text(
            coins,
            style: TextStyle(
              color: theme.colorScheme.surface,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    return dataAsync.when(
      data: (data) => AppBar(
        automaticallyImplyLeading: false,
        title: Image.asset(
          R.logo,
          height: 32,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
        ),
        actions: [
          coinsButton(data?["coins"]?.toString() ?? "0"),
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
      ),
      error: (_, __) => AppBar(
        automaticallyImplyLeading: false,
        title: Image.asset(
          R.logo,
          height: 32,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
        ),
        actions: [
          coinsButton("--"),
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
      ),
      loading: () => AppBar(
        automaticallyImplyLeading: false,
        title: Image.asset(
          R.logo,
          height: 32,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
        ),
        actions: [
          coinsButton("..."),
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
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
