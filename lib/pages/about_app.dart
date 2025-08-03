import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({Key? key}) : super(key: key);

  void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // Handle error if URL can't be launched
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('About App'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo in the center
            Center(
              child: Image.asset(
                'assets/logo.png', // Place your logo asset here
                width: 120,
                height: 120,
              ),
            ),
            const SizedBox(height: 24),

            // Description with clickable links (no explicit style)
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Welcome to the App! This app is designed to simplify your workflow and keep you productive. For more info, visit our ',
                  ),
                  TextSpan(
                    text: 'website',
                    recognizer: TapGestureRecognizer()..onTap = () => _launchUrl('https://example.com'),
                  ),
                  const TextSpan(text: ' or check out our '),
                  TextSpan(
                    text: 'GitHub repository',
                    recognizer: TapGestureRecognizer()..onTap = () => _launchUrl('https://github.com/example'),
                  ),
                  const TextSpan(text: ' for the code.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
