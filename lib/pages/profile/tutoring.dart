import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/tutoring_provider.dart';
import '../../widgets/tutoring_tile.dart';
import 'package:studyswap/providers/traslation_provider.dart';
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
            return Padding(
              padding: const EdgeInsets.only(top: 64.0),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.no_sim_rounded,
                      size: 48,
                    ),
                    SizedBox(height: 16),
                    Text(Translation.of(context)!.translate("profile.noTutoring")),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: tutoringList.length,
            itemBuilder: (context, index) {
              final tutoring = tutoringList[index];

              return TutoringTile(
                title: tutoring['subject'] ?? Translation.of(context)!.translate("profile.noTitle"),
                isYearSelected: (tutoring['classes'] as List<dynamic>?)
                    ?.cast<bool>() ??
                    [],
                description: tutoring['description'] ?? Translation.of(context)!.translate("profile.noDescription"),
                userId: userId,
                tutoringId: tutoring['id'] ?? "",
                hours: tutoring['hours'] ?? 0,
                mode: tutoring['mode'] ?? Translation.of(context)!.translate("profile.noMode"),
                contactHandle: tutoring['contact_handle'],
                contactPlatform: tutoring['contact_platform'],
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
