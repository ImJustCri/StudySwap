import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studyswap/providers/search_results_provider.dart';
import 'package:studyswap/services/traslation_manager.dart';
import '../search_post.dart';

class BooksResults extends ConsumerWidget {
  final String searchQuery;

  const BooksResults({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksAsyncValue = ref.watch(booksByTitlePrefixProvider(searchQuery));

    return booksAsyncValue.when(
      data: (books) {
        if (books.isEmpty) {
          return Center(child: Text(Translation.of(context)!.translate("results.noBooks")));
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: books.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final book = books[index];
              return SearchPost.fromMap(book);
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
