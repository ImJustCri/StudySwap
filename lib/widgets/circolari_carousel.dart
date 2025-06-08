import 'package:flutter/material.dart';
import 'circolare_content.dart';
import 'package:http/http.dart' as http;
import 'package:dart_rss/dart_rss.dart';

final client = http.Client();

class CircolariCarousel extends StatefulWidget {
  const CircolariCarousel({super.key});

  @override
  State<CircolariCarousel> createState() => _CircolariCarouselState();
}

class _CircolariCarouselState extends State<CircolariCarousel> {
  List<RssItem> _items = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchRssFeed();
  }

  Future<void> _fetchRssFeed() async {
    try {
      final response = await client.get(Uri.parse('https://isradice.edu.it/circolare/rss/'));
      if (response.statusCode == 200) {
        final rssFeed = RssFeed.parse(response.body);
        setState(() {
          _items = rssFeed.items;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load feed: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  String cleanCircolareTitle(String title) {
    final pattern = RegExp(r'^\d{1,2}-\d{1,2}\.\s*Circolare n\. \d+\s*', caseSensitive: false);
    return title.replaceFirst(pattern, '').trim();
  }

  String? extractCircolareNumber(String title) {
    final numberPattern = RegExp(r'Circolare n\. (\d+)', caseSensitive: false);
    final match = numberPattern.firstMatch(title);
    if (match != null && match.groupCount >= 1) {
      return match.group(1);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(child: Text(_error!));
    }

    return SizedBox(
      height: 144,
      width: double.infinity,
      child: CarouselView(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        itemSnapping: true,
        shrinkExtent: 330,
        itemExtent: 330,
        children: _items.map((item) {
          final originalTitle = item.title ?? 'No title';
          final cleanedTitle = cleanCircolareTitle(originalTitle);
          final circolareNumber = extractCircolareNumber(originalTitle) ?? 'Unknown';

          return CircolareContent(
            number: circolareNumber,
            title: cleanedTitle,
          );
        }).toList(),
      ),
    );
  }
}
