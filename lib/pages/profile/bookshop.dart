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
          userBooksAsyncValue.when(
            data: (booksList) {
              if (booksList.isEmpty) {
                return const Center(child: Text('No books uploaded.'));
              }
              final posts = booksList.map((bookData) => Post.fromMap(bookData)).toList();

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.7,
                ),
                itemCount: posts.length,
                itemBuilder: (context, index) => posts[index],
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
