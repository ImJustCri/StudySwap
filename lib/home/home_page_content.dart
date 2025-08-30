import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studyswap/home/suggested_notes.dart';
import 'package:studyswap/pages/settings/favorite_subjects.dart';
import 'package:studyswap/widgets/circolari_carousel.dart';
import 'latest_notes.dart';

class HomePageContent extends ConsumerWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDataAsync = ref.watch(userDataProvider);

    final favorites = userDataAsync.maybeWhen(
      data: (userData) {
        if (userData != null && userData['favorite_subjects'] is List) {
          return (userData['favorite_subjects'] as List).whereType<String>().toSet();
        }
        return <String>{};
      },
      orElse: () => <String>{},
    );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24.0, top: 24.0),
            child: const CircolariCarousel(),
          ),

          SuggestedNotesSection(favorites: favorites),

          const SizedBox(height: 8),
          LatestNotesSection(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
