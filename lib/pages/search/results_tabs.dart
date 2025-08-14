import 'package:flutter/material.dart';

class ResultsTabs extends StatelessWidget {
  final TabController? controller;

  const ResultsTabs({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: TabBar(
        controller: controller,
        isScrollable: true,
        tabAlignment: TabAlignment.center,
        tabs: const [
          Tab(text: "Notes"),
          Tab(text: "Books"),
          Tab(text: "Profiles"),
        ],
      ),
    );
  }
}
