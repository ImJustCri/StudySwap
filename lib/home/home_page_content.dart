import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studyswap/widgets/circolari_carousel.dart';
import 'package:studyswap/widgets/post.dart';
import '../providers/notes_provider.dart';

final List<Post> suggestedPosts = [];  // TODO: Algorithm for Suggested Posts

class HomePageContent extends ConsumerWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsyncValue = ref.watch(notesProvider);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 24.0, top: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircolariCarousel(),
            const SizedBox(height: 16),

            const Text(
              "Suggested",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 244,
              child: suggestedPosts.isEmpty
                  ? const Center(child: Text('No suggested posts.'))
                  : ListView(
                scrollDirection: Axis.horizontal,
                children: suggestedPosts.asMap().entries.expand((entry) {
                  int i = entry.key;
                  Post post = entry.value;
                  return [
                    InkWell(
                      onTap: () {},
                      child: post,
                    ),
                    if (i != suggestedPosts.length - 1) const SizedBox(width: 16)
                    else const SizedBox(width: 24),
                  ];
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              "Latest notes",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 244,
              child: notesAsyncValue.when(
                data: (notesList) {
                  if (notesList.isEmpty) {
                    return const Center(child: Text('No notes available.'));
                  }

                  final fetchedPosts = notesList.map((noteData) => Post.fromMap(noteData)).toList();

                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children: fetchedPosts.asMap().entries.expand((entry) {
                      int i = entry.key;
                      Post post = entry.value;
                      return [
                        InkWell(
                          onTap: () {},
                          child: post,
                        ),
                        if (i != fetchedPosts.length - 1) const SizedBox(width: 16)
                        else const SizedBox(width: 24),
                      ];
                    }).toList(),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(child: Text('Error loading notes: $error')),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
