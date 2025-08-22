import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/books_provider.dart';
import '../../providers/notes_provider.dart';
import '../../widgets/post.dart';
import 'package:studyswap/providers/traslation_provider.dart';
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

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: fetchedPosts.map((post) {
            return ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 200, maxWidth: 320),
              child: Material(
                type: MaterialType.transparency,
                child: post,
              ),
            );
          }).toList(),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Translation.of(context)!.translate("moreUser.title")+"$username",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        isBook
            ? booksAsyncValue.when(
          data: (bookList) => buildListFromData(bookList, Translation.of(context)!.translate("moreUser.noBook"), Translation.of(context)!.translate("moreUser.errorBook")),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text(Translation.of(context)!.translate("moreUser.errorBook")+": $error")),
        )
            : notesAsyncValue.when(
          data: (noteList) => buildListFromData(noteList, Translation.of(context)!.translate("moreUser.noNotes"), Translation.of(context)!.translate("moreUser.errorNotes")),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text(Translation.of(context)!.translate("moreUser.errorNotes")+": $error")),
        ),
      ],
    );
  }
}
