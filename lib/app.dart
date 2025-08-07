import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studyswap/first_run.dart';
import 'package:studyswap/pages/about_app.dart';
import 'package:studyswap/pages/onboarding/onboarding_page.dart';
import 'package:studyswap/pages/profile/edit_profile.dart';
import 'package:studyswap/pages/settings/favorite_subjects.dart';
import 'package:studyswap/pages/settings/settings_page.dart';
import 'package:studyswap/pages/upload/books.dart';
import 'package:studyswap/pages/upload/notes.dart';
import 'package:studyswap/pages/upload/tutoring.dart';
import 'package:studyswap/providers/subjects_providers.dart';
import 'package:studyswap/providers/theme_provider.dart';
import 'app_theme.dart';
import 'home/home_page.dart';
import 'package:studyswap/pages/login.dart';
import 'package:studyswap/pages/register.dart';
import 'package:studyswap/pages/notifications_page.dart';
import 'pages/password_recovery.dart';


class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    setOptimalDisplayMode();
    super.initState();
  }

  Future<void> setOptimalDisplayMode() async {
    final List<DisplayMode> supported = await FlutterDisplayMode.supported;
    final DisplayMode active = await FlutterDisplayMode.active;

    final List<DisplayMode> sameResolution = supported.where(
            (DisplayMode m) => m.width == active.width
            && m.height == active.height).toList()..sort(
            (DisplayMode a, DisplayMode b) =>
            b.refreshRate.compareTo(a.refreshRate));

    final DisplayMode mostOptimalMode = sameResolution.isNotEmpty
        ? sameResolution.first
        : active;

    await FlutterDisplayMode.setPreferredMode(mostOptimalMode);
  }

  @override
  Widget build(BuildContext context) {
    final darkModeAsync = ref.watch(darkModeProvider);

    ThemeMode themeMode = ThemeMode.light;

    darkModeAsync.when(
      data: (darkmode) {
        if (darkmode != null) {
          themeMode = darkmode ? ThemeMode.dark : ThemeMode.light;
        }
      },
      loading: () {
        themeMode = ThemeMode.light;
      },
      error: (_, __) {
        themeMode = ThemeMode.light;
      },
    );

    return MaterialApp(
      title: 'StudySwap',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      initialRoute: '/',
      routes: {
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
      },
      home: const LandingPage(),
    );
  }
}
