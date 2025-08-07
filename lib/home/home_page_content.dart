import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studyswap/pages/settings/favorite_subjects.dart';
import 'package:studyswap/providers/subjects_providers.dart';
import 'package:studyswap/widgets/circolari_carousel.dart';
import 'package:studyswap/widgets/post.dart';
import '../providers/books_provider.dart';
import '../providers/notes_provider.dart';
import '../widgets/view_all_uploads.dart';

class HomePageContent extends ConsumerWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final userDataAsync = ref.watch(userDataProvider);
    final lastNotesAsyncValue = ref.watch(last20NotesProvider);
    final notesAsyncValue = ref.watch(notesProvider);
    final suggestedAsync = ref.watch(suggestedNotesProvider);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 24.0, top: 24.0, bottom: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircolariCarousel(),
            const SizedBox(height: 16),

            const Text(
              "Suggested",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),

            userDataAsync.when(
              data: (userData) {
                if (userData != null && userData['favorite_subjects'] is List) {
                  final favorites =
                  (userData['favorite_subjects'] as List).whereType<String>().toSet();

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
                                  onPressed: () => Navigator.pushNamed(context, "/favorite-subjects"),
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
                        // Keep the original fixed height when empty
                        return SizedBox(
                          height: 192,
                          child: const SizedBox.shrink(),
                        );
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
                              onTap: () {},
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

                // If userData null or missing favorite_subjects fallback:
                return const SizedBox.shrink();
              },
              loading: () => SizedBox(
                height: 192,
                child: const Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) => SizedBox(
                height: 192,
                child: Center(child: Text('Error loading user data: $error')),
              ),
            ),

            const SizedBox(height: 24),

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
                          builder: (_) => ViewAllUploadsPage(notesProvider: notesProvider, "Notes"),
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
                        onTap: () {},
                        child: post,
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(width: 16),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(child: Text('Error loading notes: $error')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
