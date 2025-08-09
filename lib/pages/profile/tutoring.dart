import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/tutoring_provider.dart';
import '../../widgets/tutoring_tile.dart';

class Tutoring extends ConsumerWidget {
  final String userId;

  const Tutoring({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tutoringAsyncValue = ref.watch(userTutoringProvider(userId));

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: tutoringAsyncValue.when(
        data: (tutoringList) {
          if (tutoringList.isEmpty) {
            return const Center(child: Text('No tutoring sessions available.'));
          }

          return ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: tutoringList.length,
            itemBuilder: (context, index) {
              final tutoring = tutoringList[index];

              return TutoringTile(
                key: ValueKey(index),
                title: tutoring['subject'] ?? 'No title',
                isYearSelected: tutoring['classes'].cast<bool>(),
                description: tutoring['description'] ?? "No description",
                userId: userId,
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 16),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}