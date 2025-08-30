import 'package:flutter/material.dart';
import 'package:studyswap/services/traslation_manager.dart';
import 'package:studyswap/services/updates_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({super.key});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  late Future<String?> _latestVersionFuture;

  @override
  void initState() {
    super.initState();
    _latestVersionFuture = UpdatesManager.fetchLatestVersion();
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.download_for_offline_rounded,
              size: 64,
            ),
            const SizedBox(height: 8),
            Text(
              Translation.of(context)!.translate("update.title"),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            FutureBuilder<String?>(
              future: _latestVersionFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text(
                    '...',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text(
                    'Error fetching version',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.error,
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return Text(
                    'No version info available',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                    ),
                  );
                }
                return SizedBox(
                  width: 300,
                  child: Text(
                    snapshot.data!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 300,
              child: Text(
                Translation.of(context)!.translate("update.body"),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 8),
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

