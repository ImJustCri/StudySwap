import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/post.dart';

class ViewAllUploadsPage extends ConsumerWidget {
  final StreamProvider<List<Map<String, dynamic>>> notesProvider;
  final String type;

  const ViewAllUploadsPage(this.type, {super.key, required this.notesProvider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsyncValue = ref.watch(notesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('All $type'),
      ),
      body: notesAsyncValue.when(
        data: (notesList) {
          if (notesList.isEmpty) {
            return const Center(child: Text('No notes available.'));
          }

          final posts = notesList.map((noteData) => Post.fromMap(noteData)).toList();

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.7,
            ),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return posts[index];
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error loading notes: $error')),
      ),
    );
  }
}
