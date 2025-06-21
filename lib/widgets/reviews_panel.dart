import 'package:flutter/material.dart';

class ReviewsPanel extends StatelessWidget {
  final double stars;
  final List<int> reviewCounts;
  final int totalReviews;

  const ReviewsPanel({
    super.key,
    required this.stars,
    required this.reviewCounts,
    required this.totalReviews,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryFixed,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _AverageRating(
              stars: stars,
              totalReviews: totalReviews,
            ),
            const SizedBox(width: 32),
            Expanded(
              child: _ReviewBars(
                reviewCounts: reviewCounts,
                totalReviews: totalReviews,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AverageRating extends StatelessWidget {
  final double stars;
  final int totalReviews;

  const _AverageRating({
    required this.stars,
    required this.totalReviews,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          stars.toStringAsFixed(1),
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          "$totalReviews reviews",
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _ReviewBars extends StatelessWidget {
  final List<int> reviewCounts;
  final int totalReviews;

  const _ReviewBars({
    required this.reviewCounts,
    required this.totalReviews,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final star = 5 - index;
        final count = reviewCounts[index];
        final barFraction = totalReviews > 0 ? count / totalReviews : 0.0;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: _ReviewBar(
            star: star,
            fraction: barFraction,
          ),
        );
      }),
    );
  }
}

class _ReviewBar extends StatelessWidget {
  final int star;
  final double fraction;

  const _ReviewBar({
    required this.star,
    required this.fraction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Text(
          '$star',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 4),
        Icon(Icons.star, color: theme.colorScheme.onSurface, size: 14),
        const SizedBox(width: 6),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              FractionallySizedBox(
                widthFactor: fraction,
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
