import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/reviews_provider.dart';
import '../../widgets/reviews/review_bottom_sheet.dart';
import '../../widgets/reviews/reviews_list.dart';
import '../../widgets/reviews/reviews_panel.dart';

class Reviews extends ConsumerStatefulWidget {
  final double stars;
  final String userId;
  final bool isMine;
  const Reviews({super.key, required this.stars, required this.userId, required this.isMine});

  @override
  ConsumerState<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends ConsumerState<Reviews> {
  int _selectedRating = 0;

  void _showReviewDialog() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => ReviewBottomSheet(initialRating: _selectedRating, profile: widget.userId),
    );

    if (result != null) {
      setState(() {
        _selectedRating = result['rating'] as int;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thank you for your review!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Watch the providers that give the review counts per rating and total reviews
    final ratingCountsAsyncValue = ref.watch(userReviewsRatingCountProvider(widget.userId));
    final totalReviewsAsyncValue = ref.watch(userReviewsCountProvider(widget.userId));

    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ratingCountsAsyncValue.when(
            data: (reviewCounts) => totalReviewsAsyncValue.when(
              data: (totalReviews) {
                return ReviewsPanel(
                  stars: widget.stars,
                  reviewCounts: reviewCounts,
                  totalReviews: totalReviews,
                );
              },
              loading: () => const SizedBox(height: 128, child: Center(child: CircularProgressIndicator())),
              error: (error, stack) => Text('Error loading total reviews: $error'),
            ),
            loading: () => const SizedBox(height: 128, child: Center(child: CircularProgressIndicator())),
            error: (error, stack) => Text('Error loading rating counts: $error'),
          ),

          const SizedBox(height: 24),

          if (!widget.isMine)
            TextButton.icon(
              style: TextButton.styleFrom(
                side: BorderSide(
                  width: 0.5,
                  color: theme.colorScheme.secondary,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: Icon(
                Icons.rate_review_outlined,
                color: theme.colorScheme.secondary,
              ),
              label: Text(
                'Leave a Review',
                style: TextStyle(color: theme.colorScheme.secondary),
              ),
              onPressed: _showReviewDialog,
            )
          else
            const SizedBox.shrink(),

          // Show the full review list from userReviewsProvider
          ref.watch(userReviewsProvider(widget.userId)).when(
            data: (reviews) => ReviewList(reviews: reviews),
            loading: () => const Padding(
              padding: EdgeInsets.only(top: 24.0),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stack) => Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Center(child: Text('Error loading reviews: $error')),
            ),
          ),
        ],
      ),
    );
  }
}