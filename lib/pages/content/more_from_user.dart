import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/books_provider.dart';
import '../../providers/notes_provider.dart';
import '../../widgets/post.dart';

class MoreFromUser extends ConsumerWidget {
  final bool isBook;
  final String userId;
  final String? username;

  const MoreFromUser({
    super.key,
    required this.userId,
    required this.isBook,
    required this.username,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsyncValue = ref.watch(userNotesProvider(userId));
    final booksAsyncValue = ref.watch(userBooksProvider(userId));

    Widget buildListFromData(List<Map<String, dynamic>> data, String emptyMessage, String errorMessage) {
      final fiveItems = data.length > 5 ? data.sublist(0, 5) : data;

      if (fiveItems.isEmpty) {
        return Center(child: Text(emptyMessage));
      }

      final fetchedPosts = fiveItems.map((item) => Post.fromMap(item)).toList();

      return ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: fetchedPosts.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          return fetchedPosts[index];
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "More from $username",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 244,
          child: isBook
              ? booksAsyncValue.when(
            data: (bookList) =>
                buildListFromData(bookList, 'No books available.', 'Error loading books.'),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('Error loading books: $error')),
          )
              : notesAsyncValue.when(
            data: (noteList) =>
                buildListFromData(noteList, 'No notes available.', 'Error loading notes.'),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('Error loading notes: $error')),
          ),
        ),
      ],
    );
  }
}
