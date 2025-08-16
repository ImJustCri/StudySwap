import 'package:flutter/material.dart';

import 'media_viewer/media_display_page.dart';

class BoughtPost extends StatelessWidget {
  final String noteId;
  final int price;
  final String sellerId;
  final String subject;
  final String title;
  final String noteUrl;

  const BoughtPost({
    super.key,
    required this.noteId,
    required this.price,
    required this.sellerId,
    required this.subject,
    required this.title,
    required this.noteUrl,
  });

  void _handleTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MediaDisplayPage(
          url: noteUrl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => _handleTap(context),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subject,
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.secondary),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            IntrinsicWidth(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(50),
                ),
                alignment: Alignment.center,
                child: Text(
                  '$price',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  factory BoughtPost.fromMap(Map<String, dynamic> map) {
    return BoughtPost(
      noteId: map['noteId'] ?? '',
      price: map['price'] ?? 0,
      sellerId: map['sellerId'] ?? '',
      subject: map['subject'] ?? 'Unknown',
      title: map['title'] ?? 'No Title',
      noteUrl: map['note_url'] ?? 'https://studyswap.it/404',
    );
  }
}
