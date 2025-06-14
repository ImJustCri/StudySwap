import 'package:flutter/material.dart';

class Tabs extends StatelessWidget {
  const Tabs({super.key});

  @override
  Widget build(BuildContext context) {
    final defaultStyle = Theme.of(context).textTheme.bodyMedium!;

    return TabBar(
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      labelColor: Theme.of(context).colorScheme.onSurface,
      unselectedLabelColor: Theme.of(context).colorScheme.secondary,
      indicator: BoxDecoration(),
      dividerColor: Colors.transparent,
      labelStyle: defaultStyle.copyWith(
        fontWeight: FontWeight.w500,
        fontSize: 18,
      ),
      unselectedLabelStyle: defaultStyle.copyWith(
        fontWeight: FontWeight.normal,
        fontSize: 18,
      ),
      overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
          return Theme.of(context).colorScheme.secondaryFixedDim;
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
