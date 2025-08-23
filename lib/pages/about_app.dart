import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:studyswap/providers/traslation_provider.dart';
class AboutAppPage extends StatefulWidget {
  const AboutAppPage({super.key});

  @override
  State<AboutAppPage> createState() => _AboutAppPageState();
}

class _AboutAppPageState extends State<AboutAppPage> {
  PackageInfo _packageInfo = PackageInfo(
    version: 'Unknown version',
    buildNumber: 'Unknown build number',
    appName: 'App',
    packageName: 'Unknown package name',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

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
        title: Text(
           "${Translation.of(context)!.translate("about.title")} ${_packageInfo.appName}",
          style: const TextStyle(fontWeight: FontWeight.bold),
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
            const SizedBox(height: 8),
            Text(
              _packageInfo.version,
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
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              icon: Icon(
                Icons.link,
                color: theme.colorScheme.onSurface,
              ),
              label:  Text(Translation.of(context)!.translate("about.button")),
            ),
          ],
        ),
      ),
    );
  }
}
