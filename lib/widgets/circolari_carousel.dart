import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dart_rss/dart_rss.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../widgets/circolare_content.dart';

final _httpClient = http.Client();

final circolariFeedProvider = FutureProvider<List<RssItem>>((ref) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null || user.email == null) {
    throw Exception("User not logged in");
  }
  final emailDomain = user.email!.split('@')[1];

  final response =
  await _httpClient.get(Uri.parse('https://$emailDomain/circolare/rss/'));

  if (response.statusCode != 200) {
    throw Exception('Failed to load feed: ${response.statusCode}');
  }

  return RssFeed.parse(response.body).items;
});

// Helper to convert RSS pubDate to readable format
String? readableDate(String? date) {
  if (date == null) return null;
  try {
    DateTime dateTime = DateFormat("EEE, dd MMM yyyy HH:mm:ss Z").parse(date);
    return DateFormat("dd/MM/yyyy").format(dateTime);
  } catch (e) {
    return null;
  }
}

class CircolariCarousel extends ConsumerWidget {
  const CircolariCarousel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final feedAsync = ref.watch(circolariFeedProvider);

    return feedAsync.when(
      data: (items) {
        if (items.isEmpty) {
          return const SizedBox.shrink();
        }

        final itemWidgets = items.map((item) {
          final title = item.title ?? 'No title';
          final date = readableDate(item.pubDate) ?? 'No date';

          return CircolareContent(
            date: date,
            title: title,
          );
        }).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              "Latest from your school",
              style: TextStyle(
                fontSize: 18,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 144,
              width: double.infinity,
              child: CarouselView(
                onTap: (int index) async {
                  final selectedItem = items[index];
                  final link = selectedItem.link ?? "";
                  if (link.isEmpty) return;

                  final uri = Uri.parse(link);

                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Could not launch URL')),
                    );
                  }
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: theme.colorScheme.primaryContainer,
                itemSnapping: true,
                shrinkExtent: 330,
                itemExtent: 330,
                children: itemWidgets,
              ),
            ),
            const SizedBox(height: 24),
          ],
        );
      },
      loading: () {
        final placeholderItems = List.generate(
          3,
              (index) => const CircolareContent(
            date: "",
            title: "",
          ),
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              "Latest from your school",
              style: TextStyle(
                fontSize: 18,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 144,
              width: double.infinity,
              child: CarouselView(
                onTap: (_) {},
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: theme.colorScheme.primaryContainer,
                itemSnapping: true,
                shrinkExtent: 330,
                itemExtent: 330,
                children: placeholderItems,
              ),
            ),
            const SizedBox(height: 24),
          ],
        );
      },
      error: (error, _) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
              child: Text(
                'Error loading feed: $error',
                style: TextStyle(color: theme.colorScheme.error),
              )),
        );
      },
    );
  }
}
