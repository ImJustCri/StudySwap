import 'package:flutter/material.dart';
import 'circolare_content.dart';
import 'package:http/http.dart' as http;
import 'package:dart_rss/dart_rss.dart';
import 'package:intl/intl.dart';

final client = http.Client();

String? readableDate(String? date) {
  DateTime dateTime = DateFormat("EEE, dd MMM yyyy HH:mm:ss Z").parse(date!);
  String formattedDate = DateFormat("dd/MM/yyyy").format(dateTime);
  return formattedDate;
}

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
        backgroundColor: theme.colorScheme.primaryContainer,
        itemSnapping: true,
        shrinkExtent: 330,
        itemExtent: 330,
        children: _items.map((item) {
          final title = item.title ?? 'No title';
          final date = readableDate(item.pubDate) ?? 'No date';
          return CircolareContent(
            date: date,
            title: title,
          );
        }).toList(),
      ),
    );
  }
}
