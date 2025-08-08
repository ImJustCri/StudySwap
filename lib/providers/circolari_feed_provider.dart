import 'package:dart_rss/domain/rss_feed.dart';
import 'package:dart_rss/domain/rss_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final circolariFeedProvider = FutureProvider<List<RssItem>>((ref) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null || user.email == null) {
    throw Exception("User not logged in");
  }
  final emailDomain = user.email!.split('@')[1];
  final response = await http.Client().get(Uri.parse('https://$emailDomain/circolare/rss/'));
  if (response.statusCode != 200) {
    throw Exception('Failed to load feed: ${response.statusCode}');
  }
  return RssFeed.parse(response.body).items;
});
