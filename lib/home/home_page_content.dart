import 'package:flutter/material.dart';
import 'package:studyswap/widgets/circolari_carousel.dart';  // Import the new carousel widget

class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Latest from <School Name>",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          CircolariCarousel(),
        ],
      ),
    );
  }
}
