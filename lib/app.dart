import 'package:flutter/material.dart';
import 'package:studyswap/first_run.dart';
import 'package:studyswap/pages/about_app.dart';
import 'package:studyswap/pages/onboarding/onboarding_page.dart';
import 'package:studyswap/pages/profile/edit_profile.dart';
import 'package:studyswap/pages/settings/settings_page.dart';
import 'package:studyswap/pages/upload/books.dart';
import 'package:studyswap/pages/upload/notes.dart';
import 'package:studyswap/pages/upload/tutoring.dart';
import 'app_theme.dart';
import 'home/home_page.dart';
import 'package:studyswap/pages/login.dart';
import 'package:studyswap/pages/register.dart';
import 'package:studyswap/pages/notifications_page.dart';
import 'pages/password_recovery.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudySwap',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
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
      },
      home: LandingPage(),
    );
  }
}
