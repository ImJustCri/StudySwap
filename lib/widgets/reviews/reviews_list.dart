import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/data_provider.dart';
import '../../pages/profile/profile_page.dart';

class ReviewList extends ConsumerWidget {
  final List<Map<String, dynamic>> reviews;

  const ReviewList({super.key, required this.reviews});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Column(
      children: reviews.map((review) {
        final reviewerId = (review['reviewerId'] ?? 'username') as String;
        final rating = (review['rating'] ?? 0) as int;
        final reviewMessage = (review['review'] ?? '') as String;

        return Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: Consumer(builder: (context, ref, _) {
            final reviewerDataAsync = ref.watch(dataProvider(reviewerId));

            return reviewerDataAsync.when(
              data: (reviewerData) {
                final username = (reviewerData?['username'] ?? "deleted") as String;
                final school = (reviewerData?['school'] ?? 'user') as String;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfilePage(userId: reviewerId),
                              ),
                            );
                          },
                          child: Text(
                            username,
                            style: const TextStyle(
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Text(
                            school,
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSecondaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          size: 24,
                          color: theme.colorScheme.primary,
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      reviewMessage,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Text('Error loading user data: $e'),
            );
          }),
        );
      }).toList(),
    );
  }
}
