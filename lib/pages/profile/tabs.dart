import 'package:flutter/material.dart';
import 'package:studyswap/providers/traslation_provider.dart';
class Tabs extends StatelessWidget {
  const Tabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child:  TabBar(
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        physics: ClampingScrollPhysics(),
        tabs: [
          Tab(text: Translation.of(context)!.translate("profile.tabs.notes")),
          Tab(text: Translation.of(context)!.translate("profile.tabs.book")),
          Tab(text: Translation.of(context)!.translate("profile.tabs.tutoring")),
          Tab(text: Translation.of(context)!.translate("profile.tabs.review")),
        ],
      ),
    );
  }
}
