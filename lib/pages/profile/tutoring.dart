import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/contact_provider.dart';
import '../../providers/tutoring_provider.dart';
import '../../widgets/tutoring_tile.dart';
import 'package:studyswap/services/traslation_manager.dart';
class Tutoring extends ConsumerWidget {
  final String userId;

  const Tutoring({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tutoringAsyncValue = ref.watch(userTutoringProvider(userId));
    final contact = ref.watch(contactProvider(userId)).value;

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
                contactHandle: contact?['handle'] ?? Translation.of(context)!.translate("profile.noContact.explanation"),
                contactPlatform: contact?['platform'] ?? Translation.of(context)!.translate("profile.noContact.title"),
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
