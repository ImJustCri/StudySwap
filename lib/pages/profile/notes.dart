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
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Latest uploads",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          userNotesAsyncValue.when(
            data: (notesList) {
              if (notesList.isEmpty) {
                return const Center(child: Text('No notes uploaded.'));
              }
              final posts = notesList.map((noteData) => Post.fromMap(noteData)).toList();

              return GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.7,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: posts.map((post) => InkWell(
                  child: post,
                )).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
          ),

        ],
      ),
    );
  }
}
