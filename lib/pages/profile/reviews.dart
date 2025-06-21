import 'package:flutter/material.dart';
import '../../widgets/reviews_panel.dart';

class Reviews extends StatefulWidget {
  final double stars;
  const Reviews({super.key, required this.stars});

  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  // Example review counts (hardcoded)
  final reviewCounts = [23, 3, 3, 2, 2];

  @override
  Widget build(BuildContext context) {
    final totalReviews = reviewCounts.reduce((a, b) => a + b);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: ReviewsPanel(
        stars: widget.stars,
        reviewCounts: reviewCounts,
        totalReviews: totalReviews,
      ),
    );
  }
}