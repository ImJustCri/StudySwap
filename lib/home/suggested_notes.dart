import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studyswap/widgets/post.dart';
import 'package:studyswap/providers/notes_provider.dart';

class SuggestedNotesSection extends ConsumerWidget {
  final Set<String> favorites;

  const SuggestedNotesSection({super.key, required this.favorites});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final notesAsyncValue = ref.watch(notesProvider);

    if (favorites.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(right: 24.0),
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

    return notesAsyncValue.when(
      data: (notesList) {
        final suggestedPostsData = notesList
            .where((note) => favorites.contains(note['subject'] as String?))
            .toList();

        if (suggestedPostsData.isEmpty) {
          return const SizedBox.shrink();
        }

        final suggestedPosts =
        suggestedPostsData.map((note) => Post.fromMap(note)).toList();

        return SizedBox(
          height: 260,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(right: 24.0, left: 16.0),
            physics: const ClampingScrollPhysics(),
            itemCount: suggestedPosts.length,
            itemBuilder: (context, index) {
              final post = suggestedPosts[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Material(
                  type: MaterialType.transparency,
                  child: Container(
                    constraints: const BoxConstraints(
                      minWidth: 200,
                      maxWidth: 320,
                    ),
                    child: post,
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(width: 16),
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
    );
  }
}