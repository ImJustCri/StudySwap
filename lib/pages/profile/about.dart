import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studyswap/providers/data_provider.dart';

class About extends ConsumerWidget {
  final String? user;
  const About({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    if (user == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('User ID is null')),
      );
    }

    final userDataAsync = ref.watch(dataProvider);

    return userDataAsync.when(
      data: (data) {
        if (data == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('No user data found')),
          );
        }

        final username = data['username'] ?? 'Unknown';
        final about = data['aboutme'] ?? 'No about info';
        final school = data['school'] ?? 'No school info';

        return Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(
                  "About $username",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  about,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.school, color: theme.colorScheme.onSurface),
                    const SizedBox(width: 8),
                    Text(
                      school,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Error: $error')),
      ),
    );
  }
}