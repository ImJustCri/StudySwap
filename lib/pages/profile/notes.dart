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
                return Padding(
                  padding: const EdgeInsets.only(top: 64.0),
                  child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.no_sim_rounded,
                            size: 48,
                          ),
                          SizedBox(height: 16),
                          Text('No notes uploaded.'),
                        ],
                      ),
                  ),
                );
              }
              final posts = notesList.map((noteData) => Post.fromMap(noteData)).toList();

              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: posts.map((post) {
                  return SizedBox(
                    width: (MediaQuery.of(context).size.width - 24 * 2 /* padding */ - 16 /* spacing */) / 2,
                    child: post,
                  );
                }).toList(),
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
