import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({Key? key}) : super(key: key);

  Future<void> _launchURL() async {
    final Uri url = Uri.parse('https://studyswap.it');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'About App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'assets/logo.png',
                width: 192,
                height: 192,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Hello!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 8),
            Text(
              'v. yet to be released',
              style: TextStyle(
                fontSize: 12,
                color: theme.textTheme.bodySmall?.color ?? Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextButton.icon(
              onPressed: _launchURL,
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.onSurface,
                backgroundColor: Colors.transparent,
                textStyle: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: theme.colorScheme.secondary,
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              icon: Icon(
                Icons.link,
                color: theme.colorScheme.onSurface,
              ),
              label: const Text('Official Website'),
            ),
          ],
        ),
      ),
    );
  }
}
