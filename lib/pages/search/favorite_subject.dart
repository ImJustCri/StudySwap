import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studyswap/widgets/post.dart';

import '../../providers/books_provider.dart';
import '../../providers/notes_provider.dart';

class FavoriteSubject extends ConsumerWidget {
  final String subject;

  const FavoriteSubject({super.key, required this.subject});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final notesAsync = ref.watch(notesBySubjectProvider(subject));
    final booksAsync = ref.watch(booksBySubjectProvider(subject));

    Widget buildSectionTitle(String title) {
      return Padding(
        padding: const EdgeInsets.only(left: 24.0, bottom: 12, top: 24),
        child: Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.normal,
            fontSize: 18,
          ),
        ),
      );
    }

    Widget buildPostList(List<Post> posts) {
      if (posts.isEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.no_sim_rounded,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'No items available for this subject',
                ),
              ],
            ),
          ),
        );
      }

      return SizedBox(
        height: 260,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemCount: posts.length,
          separatorBuilder: (_, __) => const SizedBox(width: 16),
          itemBuilder: (_, index) {
            return Material(
              type: MaterialType.transparency,
              child: Container(
                constraints: const BoxConstraints(minWidth: 200, maxWidth: 320),
                child: posts[index],
              ),
            );
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(subject),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(notesBySubjectProvider(subject));
          ref.refresh(booksBySubjectProvider(subject));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSectionTitle('Notes'),
              notesAsync.when(
                data: (notesList) {
                  final posts = notesList.map((note) => Post.fromMap(note)).toList();
                  return buildPostList(posts);
                },
                loading: () => const SizedBox(
                  height: 192,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, _) => SizedBox(
                  height: 192,
                  child: Center(child: Text('Error loading notes: $error')),
                ),
              ),

              buildSectionTitle('Books'),
              booksAsync.when(
                data: (booksList) {
                  final posts = booksList.map((book) => Post.fromMap(book)).toList();
                  return buildPostList(posts);
                },
                loading: () => const SizedBox(
                  height: 192,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, _) => SizedBox(
                  height: 192,
                  child: Center(child: Text('Error loading books: $error')),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
