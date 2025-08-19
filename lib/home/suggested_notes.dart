import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studyswap/providers/books_provider.dart';
import 'package:studyswap/providers/user_provider.dart';
import 'package:studyswap/widgets/post.dart';
import '../providers/notes_provider.dart';

class SuggestedNotesSection extends ConsumerWidget {
  final Set<String> favorites;

  const SuggestedNotesSection({super.key, required this.favorites});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final notesAsyncValue = ref.watch(last20NotesProvider);
    final currentUserID = ref.watch(userProvider).value!.uid;

    Widget buildSectionTitle(String title) {
      return Padding(
        padding: const EdgeInsets.only(left: 24.0, bottom: 12, top: 24),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
        ),
      );
    }

    if (favorites.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primaryContainer,
                theme.colorScheme.tertiaryFixedDim.withAlpha(80),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomLeft,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: theme.colorScheme.onPrimaryContainer,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Want personalized suggestions?",
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "Choose your favorite subjects in the settings to get customized recommendations.",
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, "/favorite-subjects");
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.onSurface,
                      backgroundColor: Colors.transparent,
                      textStyle: theme.textTheme.bodyMedium,
                      side: BorderSide(
                        color: theme.colorScheme.secondary,
                        width: 0.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    icon: Icon(
                      Icons.settings,
                      color: theme.colorScheme.onSurface,
                    ),
                    label: const Text("Go to settings"),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle("Suggested Notes"),
        notesAsyncValue.when(
          data: (notesList) {
            final suggestedPostsData = notesList
                .where((note) => favorites.contains(note['subject'] as String?)
                && (note['user_id'] as String?) != currentUserID)
                .toList();

            if (suggestedPostsData.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Center(
                  child: Column(
                    children: const [
                      Icon(
                        Icons.no_sim_rounded,
                        size: 48,
                      ),
                      SizedBox(height: 16),
                      Text('No suggested notes.'),
                    ],
                  ),
                ),
              );
            }

            final suggestedPosts =
            suggestedPostsData.map((note) => Post.fromMap(note)).toList();

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: suggestedPosts.map((post) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: 200,
                        maxWidth: 320,
                      ),
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
          loading: () => SizedBox(
            height: 192,
            child: const Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) => SizedBox(
            height: 192,
            child: Center(child: Text('Error loading suggestions: $error')),
          ),
        ),
      ],
    );
  }
}
