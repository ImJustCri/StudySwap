import 'package:flutter/material.dart';
import 'circolare_content.dart';
import 'package:http/http.dart' as http;
import 'package:dart_rss/dart_rss.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

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

  // Variable to hold the domain extracted from the email
  String? emailDomain;

  @override
  void initState() {
    super.initState();
    _extractEmailDomain();
    _fetchRssFeed();
  }

  void _extractEmailDomain() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.email != null) {
      final parts = user.email!.split('@');

      if (parts.length == 2) {
        emailDomain = parts[1];
      } else {
        emailDomain = null;
      }

    } else {
      emailDomain = null;
    }
  }

  Future<void> _fetchRssFeed() async {
    try {
      final response = await client.get(Uri.parse('https://${emailDomain!}/circolare/rss/'));
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
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            textAlign: TextAlign.left,
            "Latest from your school",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
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
              children: [
                Container(),
                Container(),
                Container(),
                Container(),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      );
    }

    if (_error != null) {
      return Center(child: Text(_error!));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          textAlign: TextAlign.left,
          "Latest from your school",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
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
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Future<void> _launchUrl(Uri url) async {}
}
