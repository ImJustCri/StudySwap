import 'package:flutter/material.dart';
import 'package:studyswap/widgets/post.dart';

final List<Post> posts = [
  const Post(),
  const Post(),
  const Post(),
];

class Notes extends StatelessWidget {
  const Notes({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          "Latest uploads",
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
      ],
    );
  }
}