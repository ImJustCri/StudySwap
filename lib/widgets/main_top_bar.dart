import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:studyswap/coins_page.dart';
import 'package:studyswap/providers/data_provider.dart';
import 'package:studyswap/services/traslation_manager.dart';
class TopBar extends ConsumerWidget implements PreferredSizeWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);
    final dataAsync = ref.watch(dataProvider(currentUser!.uid));

    Widget coinsButton(String coins) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 600,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(64.0),
            color: theme.colorScheme.onPrimaryContainer,
          ),
          child: TextButton.icon(
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(64.0),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CoinsPage(coins)),
              );
            },
            icon: SvgPicture.asset(
              'assets/coin_icon.svg',
              colorFilter: ColorFilter.mode(theme.colorScheme.surface, BlendMode.srcIn),
              width: 24,
              height: 24,
            ),
            label: SizedBox(
              child: Text(
                coins,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  color: theme.colorScheme.surface,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      );
    }

    AppBar buildAppBar(String coins) => AppBar(
      automaticallyImplyLeading: false,
      leadingWidth: 120,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Center(child: coinsButton(coins)),
      ),
      title: null,
      actions: [
        // IconButton(
        //   icon: const Icon(Icons.notifications),
        //   color: theme.colorScheme.onPrimaryContainer,
        //   onPressed: () {
        //     Navigator.pushNamed(context, '/notifications');
        //   },
        // ),
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, color: theme.colorScheme.onPrimaryContainer),
          onSelected: (value) {
            switch (value) {
              case 'settings':
                Navigator.pushNamed(context, '/settings');
                break;
              case 'about-app':
                Navigator.pushNamed(context, '/about-app');
                break;
              case 'bought-notes':
                Navigator.pushNamed(context, '/bought-notes');
                break;
            }
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          offset: Offset(0, 48),
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'settings',
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(Icons.settings, color: Theme.of(context).iconTheme.color),
                    SizedBox(width: 8),
                    Text(Translation.of(context)!.translate("topBar.settings")),
                  ],
                ),
              ),
            ),
            PopupMenuItem<String>(
              value: 'bought-notes',
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(Icons.sticky_note_2_rounded, color: Theme.of(context).iconTheme.color),
                    SizedBox(width: 8),
                    Text(Translation.of(context)!.translate("topBar.BoughtNotes")),
                  ],
                ),
              ),
            ),
            PopupMenuItem<String>(
              value: 'about-app',
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(Icons.info, color: Theme.of(context).iconTheme.color),
                    SizedBox(width: 8),
                    Text(Translation.of(context)!.translate("topBar.AboutApp")),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
      backgroundColor: theme.colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: 64,
    );

    return dataAsync.when(
      data: (data) => buildAppBar(data?["coins"]?.toString() ?? "0"),
      loading: () => buildAppBar("..."),
      error: (_, __) => buildAppBar("--"),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
