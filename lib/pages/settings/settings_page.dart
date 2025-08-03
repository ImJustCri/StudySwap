import 'package:flutter/material.dart';

import 'account_settings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: ListView(
          children: [
            SwitchListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              title: const Text('Device Appearance'),
              subtitle: const Text('Toggle between light and dark themes'),
              secondary: Icon(
                _isDarkMode ? Icons.nights_stay : Icons.wb_sunny,
                color: _isDarkMode ? Colors.indigo : Colors.orange,
              ),
              value: _isDarkMode,
              onChanged: (newValue) {
                setState(() {
                  _isDarkMode = newValue;
                });
              },
            ),
            const Divider(),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              leading: const Icon(Icons.account_circle),
              title: const Text('Account Settings'),
              subtitle: const Text('Manage your account information'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AccountSettingsPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
