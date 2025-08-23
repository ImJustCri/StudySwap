import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/post.dart';
import 'package:studyswap/services/traslation_manager.dart';
class ViewAllUploadsPage extends ConsumerWidget {
  final StreamProvider<List<Map<String, dynamic>>> provider;
  final String type;

  const ViewAllUploadsPage(this.type, {super.key, required this.provider});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsyncValue = ref.watch(provider);
    return Scaffold(
      appBar: AppBar(
        title: Text(Translation.of(context)!.translate("results.viewAllUploads.title")),
      ),
      body: notesAsyncValue.when(
        data: (notesList) {
          if (notesList.isEmpty) {
            return Center(child: Text(Translation.of(context)!.translate("results.viewAllUploads.body")));
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
