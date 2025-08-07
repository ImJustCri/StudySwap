import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studyswap/providers/theme_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account deleted')),
              );
              // Here you would add actual account deletion logic.
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(BuildContext context, String text, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: color ?? Theme.of(context).colorScheme.primary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkModeAsync = ref.watch(darkModeProvider);
    final updateDarkMode = ref.read(darkModeUpdateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: darkModeAsync.when(
        data: (isDarkMode) {
          final darkModeValue = isDarkMode ?? false;
          return ListView(
            children: [
              _sectionLabel(context, 'PREFERENCES'),

              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                title: const Text('Device Appearance'),
                subtitle: const Text('Toggle between light and dark themes'),
                secondary: Icon(
                  darkModeValue ? Icons.nights_stay : Icons.wb_sunny,
                  color: darkModeValue ? Colors.indigo : Colors.orange,
                ),
                value: darkModeValue,
                onChanged: (newValue) async {
                  try {
                    await updateDarkMode(newValue);
                    // Removed theme updated SnackBar here
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to update theme')),
                    );
                  }
                },
              ),
              const Divider(),

              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                leading: const Icon(Icons.edit),
                title: const Text('Favorite subjects'),
                subtitle: const Text('View and change your favorite subjects'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pushNamed(context, "/favorite-subjects");
                },
              ),

              _sectionLabel(context, 'ACCOUNT'),

              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                leading: const Icon(Icons.email),
                title: const Text('Change Email'),
                subtitle: const Text('Update your email address'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Change Email tapped')),
                  );
                },
              ),
              const Divider(height: 1),

              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                leading: const Icon(Icons.lock),
                title: const Text('Change Password'),
                subtitle: const Text('Update your password'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Change Password tapped')),
                  );
                },
              ),

              _sectionLabel(context, 'DANGER ZONE', color: Colors.red[700]),

              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title: const Text(
                  'Delete Account',
                  style: TextStyle(color: Colors.red),
                ),
                subtitle: const Text('Permanently delete your account'),
                onTap: () => _showDeleteAccountDialog(context),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error loading preferences: $error'),
        ),
      ),
    );
  }
}
