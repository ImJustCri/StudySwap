import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studyswap/widgets/post.dart';
import '../../providers/notes_provider.dart';

class Notes extends ConsumerWidget {
  final String userId;

  const Notes(this.userId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userNotesAsyncValue = ref.watch(userNotesProvider(userId));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          const Text(
            "Latest uploads",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 244,
            child: userNotesAsyncValue.when(
              data: (notesList) {
                if (notesList.isEmpty) {
                  return const Center(child: Text('No notes uploaded.'));
                }
                final posts = notesList.map((noteData) {
                  return Post.fromMap(noteData);
                }).toList();

                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: posts.length,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      // TODO
                    },
                    child: posts[index],
                  ),
                  separatorBuilder: (context, index) => const SizedBox(width: 16),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
    );
  }
}
