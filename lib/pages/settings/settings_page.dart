import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studyswap/providers/theme_provider.dart';
import 'package:studyswap/auth.dart';
import 'package:studyswap/providers/user_provider.dart';
import 'package:studyswap/services/traslation_manager.dart';

import '../../providers/language_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  void _showDeleteAccountDialog(BuildContext context) {
    final auth = Auth();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title:  Text(Translation.of(context)!.translate("settings.titleDeleteA")),
        content:  Text(
          Translation.of(context)!.translate("settings.bodyDeleteA"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child:  Text(Translation.of(context)!.translate("settings.buttonCalcelA")),
          ),
          TextButton(
            onPressed: () {
              auth.deleteAccount();
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(content: Text(Translation.of(context)!.translate("settings.MessageDeleteA"))),
              );
              Navigator.pushReplacementNamed(context, '/onboarding');
              // Here you would add actual account deletion logic.
            },
            child:  Text(
              Translation.of(context)!.translate("settings.buttonDeleteA"),
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
    final userId = ref.read(userProvider).value!.uid;
    final language = ref.read(languageProvider(userId));

    return Scaffold(
      appBar: AppBar(title:  Text(Translation.of(context)!.translate("settings.titlePage"))),
      body: darkModeAsync.when(
        data: (isDarkMode) {
          final darkModeValue = isDarkMode ?? false;
          return ListView(
            children: [
              _sectionLabel(context, Translation.of(context)!.translate("settings.preferencesTitle")),

              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                title:  Text(Translation.of(context)!.translate("settings.preferences1.title")),
                subtitle:  Text(Translation.of(context)!.translate("settings.preferences1.hint")),
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
                       SnackBar(content: Text(Translation.of(context)!.translate("settings.preferences1.error"))),
                    );
                  }
                },
              ),
              const Divider(),

              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                leading: const Icon(Icons.edit),
                title:  Text(Translation.of(context)!.translate("settings.preferences2.title")),
                subtitle:  Text(Translation.of(context)!.translate("settings.preferences2.hint")),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pushNamed(context, "/favorite-subjects");
                },
              ),

              const Divider(),

              // Language changer
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                leading: const Icon(Icons.language),
                title: Text(Translation.of(context)!.translate("settings.language.title")),
                subtitle: Text(Translation.of(context)!.translate("settings.language.hint")),
                trailing: DropdownButton<String>(
                  value: language,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(
                      value: 'en',
                      child: Text('English'),
                    ),
                    DropdownMenuItem(
                      value: 'it',
                      child: Text('Italian'),
                    ),
                  ],
                  onChanged: (value) async {
                    if (value != null) {
                      await LocaleManager.setLocale(Locale(value), userId);
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    }
                  },
                ),
              ),

              _sectionLabel(context, Translation.of(context)!.translate("settings.titleAccount")),

              // ListTile(
              //   contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              //   leading: const Icon(Icons.email),
              //   title: const Text('Change Email'),
              //   subtitle: const Text('Update your email address'),
              //   trailing: const Icon(Icons.arrow_forward_ios),
              //   onTap: () {
              //     ScaffoldMessenger.of(context).showSnackBar(
              //       const SnackBar(content: Text('Change Email tapped')),
              //     );
              //   },
              // ),
              // const Divider(height: 1),

              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                leading: const Icon(Icons.lock),
                title:  Text(Translation.of(context)!.translate("settings.account1.title")),
                subtitle:  Text(Translation.of(context)!.translate("settings.account1.hint")),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pushNamed(context, '/change-password');
                },
              ),

              _sectionLabel(context, Translation.of(context)!.translate("settings.titleDangerZone"), color: Colors.red[700]),

              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title:  Text(
                  Translation.of(context)!.translate("settings.DangerZone.title"),
                  style: TextStyle(color: Colors.red),
                ),
                subtitle:  Text(Translation.of(context)!.translate("settings.DangerZone.hint")),
                onTap: () => _showDeleteAccountDialog(context),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text("${Translation.of(context)!.translate("settings.preferencesErrorCasual")}$error"),
        ),
      ),
    );
  }
}
