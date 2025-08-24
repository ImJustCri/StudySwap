import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studyswap/providers/notes_provider.dart';
import 'package:studyswap/services/traslation_manager.dart';
import 'bought_tile.dart';

class BoughtNotes extends ConsumerWidget {
  const BoughtNotes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boughtNotesAsync = ref.watch(boughtNotesProvider);

    return boughtNotesAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(title: Text(Translation.of(context)!.translate("boughtNotes.title"))),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: Text(Translation.of(context)!.translate("boughtNotes.title"))),
        body: Center(child: Text('Error: $e')),
      ),
      data: (boughtNotes) {
        if (boughtNotes.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: Text(Translation.of(context)!.translate("boughtNotes.title"))),
            body: Center(child: Text(Translation.of(context)!.translate("boughtNotes.Empty"))),
          );
        }
        return Scaffold(
          appBar: AppBar(title: Text(Translation.of(context)!.translate("boughtNotes.title"))),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: boughtNotes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final note = boughtNotes[index];
                return BoughtPost.fromMap(note);
              },
            ),
          ),
        );
      },
    );
  }
}
