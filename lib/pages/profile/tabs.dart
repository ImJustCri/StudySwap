import 'package:flutter/material.dart';

class Tabs extends StatelessWidget {
  const Tabs({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TabBar(
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      labelColor: theme.colorScheme.onSurface,
      unselectedLabelColor: theme.colorScheme.secondary,
      indicator: BoxDecoration(),
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
          return theme.colorScheme.secondaryFixedDim;
        },
      ),
      tabs: const [
        Tab(text: "Notes"),
        Tab(text: "Bookshop"),
        Tab(text: "Tutoring"),
        Tab(text: "Reviews"),
      ],
    );
  }
}
