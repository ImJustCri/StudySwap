import 'package:flutter/material.dart';
import '../../widgets/review_bottom_sheet.dart';
import '../../widgets/reviews_panel.dart';

class Reviews extends StatefulWidget {
  final double stars;
  final String profile;
  final bool isMine;
  const Reviews({super.key, required this.stars, required this.profile, required this.isMine});

  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  final List<int> reviewCounts = [23, 3, 3, 2, 2];
  int _selectedRating = 0;

  void _showReviewDialog() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => ReviewBottomSheet(initialRating: _selectedRating, profile: widget.profile,),
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
    final totalReviews = reviewCounts.reduce((a, b) => a + b);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ReviewsPanel(
            stars: widget.stars,
            reviewCounts: reviewCounts,
            totalReviews: totalReviews,
          ),
          const SizedBox(height: 24),
          !widget.isMine ? TextButton.icon(
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
          ) : Center(),
        ],
      ),
    );
  }
}