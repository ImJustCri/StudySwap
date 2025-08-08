import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studyswap/widgets/post.dart';
import '../providers/notes_provider.dart';
import 'package:studyswap/widgets/view_all_uploads.dart';

class LatestNotesSection extends ConsumerWidget {
  const LatestNotesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final lastNotesAsyncValue = ref.watch(last20NotesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Latest notes",
                style: TextStyle(fontSize: 18),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          ViewAllUploadsPage(notesProvider: notesProvider, "Notes"),
                    ),
                  );
                },
                child: const Text('View all'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 244,
          child: lastNotesAsyncValue.when(
            data: (notesList) {
              if (notesList.isEmpty) {
                return const Center(child: Text('No notes available.'));
              }

              final lastNotesPosts =
              notesList.map((noteData) => Post.fromMap(noteData)).toList();

              return ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(right: 24.0),
                itemCount: lastNotesPosts.length,
                itemBuilder: (context, index) {
                  final post = lastNotesPosts[index];
                  return InkWell(
                    onTap: () {
                      // Add tap logic if needed
                    },
                    child: post,
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(width: 16),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) =>
                Center(child: Text('Error loading notes: $error')),
          ),
        ),
      ],
    );
  }
}
