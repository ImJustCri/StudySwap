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

              // Calculate the width for each item to create 2 columns,
              // accounting for padding and spacing (16 between items)
              final double screenWidth = MediaQuery.of(context).size.width;
              final double horizontalPadding = 24 * 2; // left + right padding
              final double spacingBetweenItems = 16;
              final double itemWidth = (screenWidth - horizontalPadding - spacingBetweenItems) / 2;

              return Wrap(
                spacing: spacingBetweenItems,
                runSpacing: 16,
                children: posts.map((post) {
                  return SizedBox(
                    width: itemWidth,
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
