import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/circolare_content.dart';
import '../providers/circolari_feed_provider.dart';
import 'package:studyswap/services/traslation_manager.dart';

/// Funzione helper per convertire la data del feed RSS in formato leggibile
String? readableDate(String? date) {
  if (date == null || date.isEmpty) return null;
  try {
    // Parsing della data dal formato RSS standard
    DateTime dateTime =
        DateFormat("EEE, dd MMM yyyy HH:mm:ss Z").parse(date);
    // Ritorna la data in formato gg/mm/yyyy
    return DateFormat("dd/MM/yyyy").format(dateTime);
  } catch (e) {
    return null;
  }
}

/// Widget Carousel che mostra le circolari in orizzontale
/// Gestisce loading, errore e visualizzazione dei dati
class CircolariCarousel extends ConsumerWidget {
  const CircolariCarousel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // Osserva il provider del feed RSS
    final feedAsync = ref.watch(circolariFeedProvider);

    return feedAsync.when(
      // Caso: dati caricati correttamente
      data: (items) {
        if (items.isEmpty) {
          return const SizedBox.shrink(); // Nessuna circolare disponibile
        }

        // Mappatura dei dati in widget CircolareContent
        final itemWidgets = items.map((item) {
          final title = item['title'] ?? 'No title';
          final date = readableDate(item['pubDate']) ?? 'No date';

          return CircolareContent(
            date: date,
            title: title,
          );
        }).toList();

        // Layout del carousel
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              Translation.of(context)!.translate("home.circolari"),
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
                  final link = selectedItem['link'] ?? "";
                  if (link.isEmpty) return;

                  final uri = Uri.parse(link);

                  // Apertura link esterno
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
      // Caso: caricamento in corso
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
              Translation.of(context)!.translate("home.circolari"),
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
      // Caso: errore nel caricamento del feed
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

