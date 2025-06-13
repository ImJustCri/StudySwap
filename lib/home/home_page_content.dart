import 'package:flutter/material.dart';
import 'package:studyswap/widgets/circolari_carousel.dart';
import 'package:studyswap/widgets/post.dart';

final List<Post> posts = [
  const Post(),
  const Post(),
  const Post(),
];

class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 24.0, top: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Latest from <School Name>",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            const CircolariCarousel(),
            const SizedBox(height: 24),
            const Text(
              "Suggested",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 244,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: posts.asMap().entries.expand((entry) {
                  int i = entry.key;
                  Post post = entry.value;
                  return [
                    InkWell(
                      onTap: () {},
                      child: post,
                    ),
                    if (i != posts.length - 1) const SizedBox(width: 16)
                    else const SizedBox(width: 24),
                  ];
                }).toList(),
              )
            ),
            const SizedBox(height: 24),
            const Text(
              "Latest notes",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
                height: 244,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: posts.asMap().entries.expand((entry) {
                    int i = entry.key;
                    Post post = entry.value;
                    return [
                      InkWell(
                        onTap: () {},
                        child: post,
                      ),
                      if (i != posts.length - 1) const SizedBox(width: 16)
                      else const SizedBox(width: 24),
                    ];
                  }).toList(),
                )
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}