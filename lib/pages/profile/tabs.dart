import 'package:flutter/material.dart';

class Tabs extends StatelessWidget {
  const Tabs({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: TabBar(
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelColor: theme.colorScheme.onSurface,
        unselectedLabelColor: theme.colorScheme.secondary,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: theme.colorScheme.onSurface,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        dividerColor: Colors.transparent,
        labelStyle: theme.textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
        unselectedLabelStyle: theme.textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.normal,
          fontSize: 18,
        ),
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
            return theme.colorScheme.surface;
          },
        ),
        tabs: const [
          Tab(text: "Notes"),
          Tab(text: "Bookshop"),
          Tab(text: "Tutoring"),
          Tab(text: "Reviews"),
        ],
      ),
    );
  }
}
