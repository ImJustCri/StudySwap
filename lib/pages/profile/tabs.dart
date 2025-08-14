import 'package:flutter/material.dart';

class Tabs extends StatelessWidget {
  const Tabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: const TabBar(
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        physics: ClampingScrollPhysics(),
        tabs: [
          Tab(text: "Notes"),
          Tab(text: "Bookshop"),
          Tab(text: "Tutoring"),
          Tab(text: "Reviews"),
        ],
      ),
    );
  }
}
