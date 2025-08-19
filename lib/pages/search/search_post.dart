import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studyswap/pages/content/posts_detail_page.dart';

class SearchPost extends StatelessWidget {
  final String userId;
  final String title;
  final String subject;
  final String description;
  final String imageUrl;
  final int price;
  final String id;
  final String contactHandle;
  final String contactPlatform;

  final String? isbn;
  final int? year;
  final String? currency;

  const SearchPost({
    super.key,
    required this.userId,
    required this.id,
    required this.title,
    required this.subject,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.contactHandle,
    required this.contactPlatform,

    this.isbn,
    this.year,
    this.currency,
  });

  void _handleTap(BuildContext context, currentUser) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetailsPage(
          id: id,
          userId: userId,
          title: title,
          subject: subject,
          price: price,
          description: description,
          imageUrl: imageUrl,
          isbn: isbn,
          year: year,
          currency: currency,
          isOfUser: currentUser == userId ? true : false,
          contactHandle: contactHandle,
          contactPlatform: contactPlatform,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final compressedImageUrl = "$imageUrl?quality=10";
    final currentUser = FirebaseAuth.instance.currentUser!.uid;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => _handleTap(context, currentUser),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 104,
              height: 64,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: imageUrl.isNotEmpty && imageUrl != "Empty"
                    ? CachedNetworkImage(
                  imageUrl: compressedImageUrl,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                  errorWidget: (context, url, error) => Container(
                    color: theme.colorScheme.secondaryContainer,
                    child: Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 32,
                        color: theme.colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                )
                    : Container(
                  color: theme.colorScheme.secondaryContainer,
                  child: const Center(
                    child: Icon(
                      Icons.note,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
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
                  IntrinsicWidth(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$price${currency ?? ''}',
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
          ],
        ),
      ),
    );
  }

  factory SearchPost.fromMap(Map<String, dynamic> map) {
    return SearchPost(
      userId: map['user_id'] ?? 'Unknown user',
      id: map['id'] ?? '',
      title: map['title'] ?? 'No Title',
      subject: map['subject'] ?? 'Unknown',
      price: map['price'] ?? 0,
      description: map['description'] ?? 'No description',
      imageUrl: map['image_url'] ?? 'Empty',
      isbn: map['isbn'],
      year: map['year'],
      currency: map['currency'],
      contactHandle: map['contact_handle'],
      contactPlatform: map['contact_platform'],
    );
  }
}
