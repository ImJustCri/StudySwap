import 'package:flutter/material.dart';
import 'package:studyswap/providers/traslation_provider.dart';
class NoInternetConnection extends StatelessWidget {
  const NoInternetConnection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.signal_wifi_bad_rounded,
              size: 64,
            ),
            SizedBox(height: 8),
            Text(
              Translation.of(context)!.translate("offline.title"),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              width: 300,
              child: Text(
                Translation.of(context)!.translate("offline.body"),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
