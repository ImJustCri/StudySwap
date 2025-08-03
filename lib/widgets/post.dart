import 'package:flutter/material.dart';

class Post extends StatelessWidget {
  final String title;
  final String subject;
  final int price;

  const Post({super.key, required this.title, required this.subject, required this.price});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 200,
            height: 244,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 200,
                  height: 148,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  title,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subject,
                  style: TextStyle(fontSize: 14, color: theme.colorScheme.secondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 16),
                Container(
                  width: 64,
                  height: 24,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onPrimaryContainer,
                    borderRadius: BorderRadius.circular(12), // pill shape
                  ),
                  child: Center(
                    child: Text(
                      price.toString(),
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: theme.colorScheme.surface),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      title: map['title'] ?? 'No Title',
      subject: map['subject'] ?? 'Unknown',
      price: map['price'] ?? 0,
    );
  }
}