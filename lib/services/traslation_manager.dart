import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Translation {
  final Locale locale;
  late Map<String, dynamic> localized;

  Translation(this.locale);

  static Translation? of(BuildContext context) {
    return Localizations.of<Translation>(context, Translation);
  }

  Future<bool> load() async {
    final jsonString =
        await rootBundle.loadString('assets/lang/${locale.languageCode}.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    localized = jsonMap;
    return true;
  }

  String translate(String key) {
    List<String> parts = key.split('.');
    dynamic value = localized;
    for (var part in parts) {
      if (value[part] != null) {
        value = value[part];
      } else {
        return "";
      }
    }
    return value.toString();
  }
}

class TranslationDelegate extends LocalizationsDelegate<Translation> {
  final Locale newLocale;

  const TranslationDelegate(this.newLocale);

  @override
  bool isSupported(Locale locale) {
    return ['en', 'it'].contains(locale.languageCode);
  }

  @override
  Future<Translation> load(Locale locale) async {
    Translation localizations = Translation(newLocale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(TranslationDelegate old) => true;
}
class LocaleManager {
  //Serve per ridisegnare tutta UI senza uscire dall'app
  static final ValueNotifier<Locale> currentLocale = ValueNotifier(
    WidgetsBinding.instance.platformDispatcher.locale.languageCode == 'it'
        ? const Locale('it')
        : const Locale('en'),
  );
  static Future<Locale?> loadLanguage(String userId) async {
    try {
      final user =
          await FirebaseFirestore.instance.collection('Users').doc(userId).get();

      if (user.exists && user.data()?['language'] != null) {
        currentLocale.value = Locale(user.data()!['language']);
        return currentLocale.value;
      } else {
        final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
        final langCode =
            ['en', 'it'].contains(deviceLocale.languageCode)
                ? deviceLocale.languageCode
                : 'en';

        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .set({'language': langCode}, SetOptions(merge: true));

        currentLocale.value = Locale(langCode);
        return currentLocale.value;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<void> setLocale(Locale newLocale, String userId) async {
    currentLocale.value = newLocale;
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .set({'language': newLocale.languageCode}, SetOptions(merge: true));
    } catch (e) {
      // gestione errore opzionale
    }
  }
}

// Per cambiare lingua tramite l'impostazioni
// await LocaleManager.setLocale(newLocale,userId);