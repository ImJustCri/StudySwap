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

    Widget buildSectionTitle(String title) {
      return Padding(
        padding: const EdgeInsets.only(left: 24.0, bottom: 8, top: 16),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: theme.textTheme.titleLarge?.color,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 24.0, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildSectionTitle("Latest notes"),
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
        lastNotesAsyncValue.when(
          data: (notesList) {
            if (notesList.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Center(child: Text('No notes available.')),
              );
            }

            final lastNotesPosts =
            notesList.map((noteData) => Post.fromMap(noteData)).toList();

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: lastNotesPosts.map((post) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 200, maxWidth: 320),
                      child: Material(
                        type: MaterialType.transparency,
                        child: post,
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            child: Center(child: Text('Error loading notes: $error')),
          ),
        ),
      ],
    );
  }
}
