import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image/image.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';

class UpdatesManager {
  static const String versionCheckUrl = 'https://studyswap.it/version.json';
  // Check if a new version is available compared to current app version
  static Future<bool> isNewVersionAvailable() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final String? latestVersionString = await fetchLatestVersion();
      if (latestVersionString == null) return false;

      final Version currentVersion = Version.parse(info.version);
      final Version latestVersion = Version.parse(latestVersionString);

      return latestVersion > currentVersion;
    } catch (e) {
      return false;
    }
  }


  static Future<String?> fetchLatestVersion() async {
    try {
      final response = await http.get(Uri.parse(versionCheckUrl));
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body) as Map<String, dynamic>;
        return jsonBody['latestVersion'] as String?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
