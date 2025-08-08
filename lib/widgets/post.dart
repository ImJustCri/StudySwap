import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:studyswap/pages/content/posts_detail_page.dart';

class Post extends StatelessWidget {
  final String userId;
  final String title;
  final String subject;
  final String description;
  final String imageUrl;
  final int price;

  const Post({
    super.key,
    required this.userId,
    required this.title,
    required this.subject,
    required this.price,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final compressedImageUrl = "$imageUrl?quality=10";

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailsPage(
              userId: userId,
              title: title,
              subject: subject,
              price: price,
              description: description,
              imageUrl: imageUrl,
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
              height: 244,
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
                          color: Theme.of(context).colorScheme.secondaryContainer,
                          child: Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 48,
                              color: Theme.of(context).colorScheme.onSecondaryContainer,
                            ),
                          ),
                        ),
                      )
                          : Container(
                        color: Theme.of(context).colorScheme.secondaryContainer,
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
                    subject,
                    style: TextStyle(fontSize: 14, color: theme.colorScheme.secondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: 64,
                    height: 24,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onPrimaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        price.toString(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.surface,
                        ),
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
      ),
    );
  }
  
  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      userId: map['user_id'] ?? 'Unknown user',
      title: map['title'] ?? 'No Title',
      subject: map['subject'] ?? 'Unknown',
      price: map['price'] ?? 0,
      description: map['description'] ?? "No description",
      imageUrl: map["image_url"] ?? "Empty",
    );
  }
}

