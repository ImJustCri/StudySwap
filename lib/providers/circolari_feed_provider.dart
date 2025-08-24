import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Client HTTP riutilizzabile
final _httpClient = http.Client();

/// Provider che recupera le circolari dal feed RSS della scuola
/// Restituisce una lista di mappe contenenti titolo, link e data di pubblicazione
final circolariFeedProvider =
    FutureProvider<List<Map<String, String>>>((ref) async {
  // Recupero utente loggato
  final user = FirebaseAuth.instance.currentUser;
  if (user == null || user.email == null) {
    throw Exception("User not logged in");
  }

  // Ottengo dominio della scuola dall'email
  final emailDomain = user.email!.split('@')[1];

  // Chiamata HTTP al feed RSS
  final response =
      await _httpClient.get(Uri.parse('https://$emailDomain/circolare/rss/'));

  // Controllo eventuali errori nella richiesta
  if (response.statusCode != 200) {
    throw Exception('Failed to load feed: ${response.statusCode}');
  }

  // Parsing XML del feed RSS
  final document = XmlDocument.parse(response.body);
  final items = document.findAllElements('item');

  // Mappatura dei dati in una lista di mappe
  return items.map((node) {
    final title = node.findElements('title').first.innerText;
    final link = node.findElements('link').first.innerText;
    final pubDate = node.findElements('pubDate').isNotEmpty
        ? node.findElements('pubDate').first.innerText
        : '';
    return {'title': title, 'link': link, 'pubDate': pubDate};
  }).toList();
});

