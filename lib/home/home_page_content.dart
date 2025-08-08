import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studyswap/home/suggested_notes.dart';
import 'package:studyswap/pages/settings/favorite_subjects.dart';
import 'package:studyswap/widgets/circolari_carousel.dart';
import 'package:studyswap/widgets/post.dart';
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
      child: Padding(
        padding: const EdgeInsets.only(left: 24.0, top: 24.0, bottom: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircolariCarousel(),
            const SizedBox(height: 16),

            const Text("Suggested", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),

            SuggestedNotesSection(favorites: favorites),

            const SizedBox(height: 24),

            LatestNotesSection(),
          ],
        ),
      ),
    );
  }
}
