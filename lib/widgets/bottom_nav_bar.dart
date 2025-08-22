import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studyswap/providers/data_provider.dart';
import 'package:studyswap/providers/traslation_provider.dart';
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

    final String imageUrl = data?["image"] ?? "https://mrskvszubvnunoowjeth.supabase.co/storage/v1/object/public/pfp/default.png";
    final pfp = CachedNetworkImageProvider(imageUrl);

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
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: Translation.of(context)!.translate("buttonNavigationBar.home"),
            ),
            NavigationDestination(
              icon: Icon(Icons.search_outlined),
              selectedIcon: Icon(Icons.search),
              label: Translation.of(context)!.translate("buttonNavigationBar.search"),
            ),
            NavigationDestination(
              icon: Icon(Icons.compare_arrows_rounded),
              selectedIcon: Icon(Icons.compare_arrows_rounded),
              label: Translation.of(context)!.translate("buttonNavigationBar.Exchange"),
            ),
            NavigationDestination(
              icon: Container(
                alignment: Alignment.center,
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: pfp,
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withValues(alpha: .5),
                      BlendMode.dstATop,
                    ),
                  ),
                ),
              ),
              selectedIcon: Container(
                alignment: Alignment.center,
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: pfp,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              label: Translation.of(context)!.translate("buttonNavigationBar.you"),
            ),
          ],
        ),
      ),
    );
  }
}
