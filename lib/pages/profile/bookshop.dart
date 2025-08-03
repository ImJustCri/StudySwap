import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/books_provider.dart';
import '../../widgets/post.dart';

class Books extends ConsumerWidget {
  final String userId;
  const Books({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userBooksAsyncValue = ref.watch(userBooksProvider(userId));
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
            child: userBooksAsyncValue.when(
              data: (notesList) {
                if (notesList.isEmpty) {
                  return const Center(child: Text('No books uploaded.'));
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