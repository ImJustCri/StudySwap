import 'package:flutter/material.dart';
import 'package:studyswap/services/traslation_manager.dart';
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
        tabs: [
          Tab(text: Translation.of(context)!.translate("profile.tabs.notes")),
          Tab(text: Translation.of(context)!.translate("rearch.tabs.book")),
          Tab(text: Translation.of(context)!.translate("rearch.tabs.profiles")),
        ],
      ),
    );
  }
}
