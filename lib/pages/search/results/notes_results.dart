import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studyswap/providers/search_results_provider.dart';
import 'package:studyswap/services/traslation_manager.dart';
import '../search_post.dart';

class NotesResults extends ConsumerWidget {
  final String searchQuery;

  const NotesResults({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsyncValue = ref.watch(notesByTitlePrefixProvider(searchQuery));

    return notesAsyncValue.when(
      data: (notes) {
        if (notes.isEmpty) {
          return Center(child: Text(Translation.of(context)!.translate("results.noNotes")));
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: notes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final note = notes[index];
              return SearchPost.fromMap(note);
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
