import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studyswap/providers/data_provider.dart';

class BottomNavBar extends ConsumerWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final dataAsync = ref.watch(dataProvider(currentUser!.uid));
    final theme = Theme.of(context);

    // Use data or fallback empty/default
    final data = dataAsync.value;

    final String displayLetter = data?["username"][0].toUpperCase() ?? "U";
    final int colorValue = data?["color"] ?? 0xFF000000;
    final Color baseColor = Color(colorValue);
    final profileTextColor = ThemeData.estimateBrightnessForColor(baseColor) == Brightness.dark
        ? Colors.white
        : Colors.black;

    return NavigationBarTheme(
      data: NavigationBarThemeData(
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              fontSize: 12,
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            );
          }
          return TextStyle(
            fontSize: 12,
            color: theme.colorScheme.secondary,
          );
        }),
        indicatorColor: Colors.transparent,
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: theme.colorScheme.secondary,
              width: 0.25,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: onItemTapped,
          backgroundColor: theme.colorScheme.surface,
          destinations: <NavigationDestination>[
            const NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            const NavigationDestination(
              icon: Icon(Icons.search_outlined),
              selectedIcon: Icon(Icons.search),
              label: 'Search',
            ),
            const NavigationDestination(
              icon: Icon(Icons.compare_arrows_rounded),
              selectedIcon: Icon(Icons.compare_arrows_rounded),
              label: 'Exchange',
            ),
            NavigationDestination(
              icon: Container(
                alignment: Alignment.center,
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: baseColor.withAlpha(128), // 0.5 alpha
                ),
                child: Text(
                  displayLetter,
                  style: TextStyle(
                    color: profileTextColor.withValues(alpha: .5),
                    fontSize: 10,
                  ),
                ),
              ),
              selectedIcon: Container(
                alignment: Alignment.center,
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: baseColor.withAlpha(255), // 1.0 alpha
                ),
                child: Text(
                  displayLetter,
                  style: TextStyle(
                    color: profileTextColor,
                    fontSize: 10,
                  ),
                ),
              ),
              label: 'You',
            ),
          ],
        ),
      ),
    );
  }
}
