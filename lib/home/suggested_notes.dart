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
        child: SizedBox(
          height: 192,
          width: double.infinity,
          child: Container(
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
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
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, "/favorite-subjects");
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.onSurface,
                      backgroundColor: Colors.transparent,
                      textStyle: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      side: BorderSide(
                        color: theme.colorScheme.secondary,
                        width: 0.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                    ),
                    icon: Icon(
                      Icons.settings,
                      color: theme.colorScheme.onSurface,
                    ),
                    label: const Text("Go to settings"),
                  ),
                ],
              ),
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
          return SizedBox(height: 192, child: const SizedBox.shrink());
        }

        final suggestedPosts =
        suggestedPostsData.map((note) => Post.fromMap(note)).toList();

        return SizedBox(
          height: 250.0,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(right: 24.0),
            physics: const ClampingScrollPhysics(),
            itemCount: suggestedPosts.length,
            itemBuilder: (context, index) {
              final post = suggestedPosts[index];
              return InkWell(
                onTap: () {
                  // Add navigation or tap handling logic if needed
                },
                child: post,
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
