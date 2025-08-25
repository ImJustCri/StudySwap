import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:studyswap/first_run.dart';
import 'package:studyswap/pages/about_app.dart';
import 'package:studyswap/pages/authentication/change_password.dart';
import 'package:studyswap/pages/authentication/register.dart';
import 'package:studyswap/pages/bought/bought_notes.dart';
import 'package:studyswap/pages/no_internet_connection.dart';
import 'package:studyswap/pages/onboarding/onboarding_page.dart';
import 'package:studyswap/pages/profile/edit_profile.dart';
import 'package:studyswap/pages/settings/favorite_subjects.dart';
import 'package:studyswap/pages/settings/settings_page.dart';
import 'package:studyswap/pages/upload/books_upload_page.dart';
import 'package:studyswap/pages/upload/notes_upload_page.dart';
import 'package:studyswap/pages/upload/tutoring_upload_page.dart';
import 'package:studyswap/providers/theme_provider.dart';
import 'app_theme.dart';
import 'home/home_page.dart';
import 'package:studyswap/pages/authentication/login.dart';
import 'package:studyswap/pages/notifications_page.dart';
import 'pages/authentication/password_recovery.dart';
import 'services/traslation_manager.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  bool splashRemoved = false;
  bool isConnectedToInternet = false;

  StreamSubscription? _internetConnectionStreamSubscription;

  @override
  void initState() {
    super.initState();
    setOptimalDisplayMode();
    _internetConnectionStreamSubscription =
        InternetConnection().onStatusChange.listen((event) {
          switch (event) {
            case InternetStatus.connected:
              setState(() {
                isConnectedToInternet = true;
              });
              break;
            case InternetStatus.disconnected:
              setState(() {
                isConnectedToInternet = false;
              });
              break;
          }
        });
  }

  @override
  void dispose() {
    super.dispose();
    _internetConnectionStreamSubscription?.cancel();
  }

  Future<void> setOptimalDisplayMode() async {
    final List<DisplayMode> supported = await FlutterDisplayMode.supported;
    final DisplayMode active = await FlutterDisplayMode.active;

    final List<DisplayMode> sameResolution = supported.where(
          (DisplayMode m) => m.width == active.width && m.height == active.height,
    ).toList()
      ..sort((a, b) => b.refreshRate.compareTo(a.refreshRate));

    final DisplayMode mostOptimalMode =
    sameResolution.isNotEmpty ? sameResolution.first : active;

    await FlutterDisplayMode.setPreferredMode(mostOptimalMode);
  }

  @override
  Widget build(BuildContext context) {
    final darkModeAsync = ref.watch(darkModeProvider);
    final user = FirebaseAuth.instance.currentUser;
    ThemeMode themeMode = ThemeMode.light;

    darkModeAsync.when(
      data: (darkmode) {
        if (user != null) {
          if (darkmode != null) {
            themeMode = darkmode ? ThemeMode.dark : ThemeMode.light;

            if (!splashRemoved) {
              FlutterNativeSplash.remove();
              splashRemoved = true;
            }
          } else {
            themeMode = ThemeMode.light;
          }
        }
        else {
          FlutterNativeSplash.remove();
        }
      },
      loading: () {
        themeMode = ThemeMode.light;
      },
      error: (_, __) {
        if (!splashRemoved) {
          FlutterNativeSplash.remove();
          splashRemoved = true;
        }

        themeMode = ThemeMode.light;
      },
    );
    return ValueListenableBuilder<Locale>(
  valueListenable: LocaleManager.currentLocale,
  builder: (context, locale, child) {
    return MaterialApp(
      title: 'StudySwap',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      locale: locale,
      initialRoute: '/',
      routes:{
        '/onboarding': (context) => const OnboardingPage(),
        '/password-recovery': (context) => const PassRecovery(),
        '/homescreen': (context) => const MyHomePage(title: "StudySwap"),
        '/notifications': (context) => const NotificationsPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/edit-profile': (context) => const EditProfile(),
        '/notes-upload': (context) => const NotesUploadPage(),
        '/books-upload': (context) => const BooksUploadPage(),
        '/tutoring-upload': (context) => const TutoringUploadPage(),
        '/settings': (context) => const SettingsPage(),
        '/about-app': (context) => const AboutAppPage(),
        '/favorite-subjects': (context) => const FavoriteSubjectsSettingsPage(),
        '/change-password': (context) => const ChangePassword(),
        '/bought-notes': (context) => BoughtNotes(),
      },
      localizationsDelegates:[
        TranslationDelegate(locale),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales:const[
        Locale('en'),
        Locale('it'),
      ],
      home: isConnectedToInternet ? LandingPage(): NoInternetConnection(),
    );
  },
);
}
}
    