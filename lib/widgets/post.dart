import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studyswap/pages/content/posts_detail_page.dart';

import '../providers/user_provider.dart';
import '../services/traslation_manager.dart';

class Post extends ConsumerWidget {
  final String userId;
  final String title;
  final String subject;
  final String description;
  final String imageUrl;
  final int price;
  final String id;
  final String contactHandle;
  final String contactPlatform;

  // Optional fields for books
  final String? isbn;
  final int? year;
  final String? currency;

  const Post( {
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

    // Optional fields for books
    this.isbn,
    this.year,
    this.currency,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final compressedImageUrl = "$imageUrl?quality=10";
    final currentUser = ref.watch(userProvider).value;
final isOfUser = currentUser != null && currentUser.uid == userId;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
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
              isOfUser: isOfUser,
              contactHandle: contactHandle,
              contactPlatform: contactPlatform,
            ),
          ),
        );
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 200,
                    height: 148,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: imageUrl.isNotEmpty && imageUrl != "Empty"
                          ? CachedNetworkImage(
                        imageUrl: compressedImageUrl,
                        width: 200,
                        height: 148,
                        fit: BoxFit.cover,
                        progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                          child: CircularProgressIndicator(
                            value: downloadProgress.progress,
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: theme.colorScheme.secondaryContainer,
                          child: Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 48,
                              color: theme.colorScheme.onSecondaryContainer,
                            ),
                          ),
                        ),
                      )
                          : Container(
                        color: theme.colorScheme.secondaryContainer,
                        child: Center(
                          child: Icon(
                            Icons.note,
                            size: 48,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    Translation.of(context)!.translate("subjectsList.$subject"),
                    style: TextStyle(fontSize: 14, color: theme.colorScheme.secondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  IntrinsicWidth(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurface,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        // Add currency (Euro by default) if a book is uploaded
                        '$price${currency ?? ''}',
                        style: TextStyle(
                          color: theme.colorScheme.surface,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      userId: map['user_id'] ?? 'Unknown user',
      id: map["id"] ?? "",
      title: map['title'] ?? 'No Title',
      subject: map['subject'] ?? 'Unknown',
      price: map['price'] ?? 0,
      description: map['description'] ?? 'No description',
      imageUrl: map['image_url'] ?? 'Empty',
      isbn: map['isbn'], // nullable
      year: map['year'], // nullable
      currency: map['currency'],
      contactHandle: map['contact_handle'],
      contactPlatform: map['contact_platform'],
    );
  }
}


