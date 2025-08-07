import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studyswap/widgets/post.dart';
import '../providers/books_provider.dart';
import '../providers/subjects_providers.dart';
import '../widgets/view_all_uploads.dart';

class ExchangePage extends ConsumerStatefulWidget {
  const ExchangePage({super.key});

  @override
  ConsumerState<ExchangePage> createState() => _ExchangePageState();
}

class _ExchangePageState extends ConsumerState<ExchangePage> {
  String? selectedSubject;

  @override
  Widget build(BuildContext context) {
    final booksAsyncValue = ref.watch(booksProvider);
    final favoriteSubjectsAsync = ref.watch(favoriteSubjectsProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 24.0, top: 24.0, right: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            favoriteSubjectsAsync.when(
              data: (favoriteSubjects) {
                final chipsSubjects = [null, ...favoriteSubjects];

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: chipsSubjects.map((subject) {
                      final isSelected = selectedSubject == subject;
                      final label = subject ?? 'All subjects';

                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(label),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              selectedSubject = selected ? subject : null;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error loading favorite subjects: $error')),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Latest books",
                  style: TextStyle(fontSize: 18),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ViewAllUploadsPage(notesProvider: booksProvider, "Books"),
                      ),
                    );
                  },
                  child: const Text('View all'),
                ),
              ],
            ),

            const SizedBox(height: 8),
            SizedBox(
              height: 244,
              child: booksAsyncValue.when(
                data: (bookList) {
                  final filteredBooks = selectedSubject == null
                      ? bookList
                      : bookList.where(
                        (book) => book['subject'] == selectedSubject,
                  ).toList();

                  if (filteredBooks.isEmpty) {
                    return const Center(child: Text('No books available for this subject.'));
                  }

                  final fetchedPosts = filteredBooks.map((noteData) => Post.fromMap(noteData)).toList();

                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: fetchedPosts.length,
                    padding: const EdgeInsets.only(right: 24),
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      return fetchedPosts[index];
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(child: Text('Error loading books: $error')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
