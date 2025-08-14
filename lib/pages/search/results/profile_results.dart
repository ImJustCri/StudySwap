import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studyswap/pages/search/profile_tile.dart';
import 'package:studyswap/providers/search_results_provider.dart';

class ProfileResults extends ConsumerWidget {
  final String searchQuery;

  const ProfileResults({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profilesAsyncValue = ref.watch(profilesByUsernamePrefixProvider(searchQuery));

    return profilesAsyncValue.when(
      data: (profile) {
        if (profile.isEmpty) {
          return Center(child: Text('No profiles found'));
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: profile.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final profileData = profile[index];
              return ProfileTile(
                userId: profileData["user_id"],
                username: profileData["username"],
                pfp: profileData["image"],
                school: profileData["school"],
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
