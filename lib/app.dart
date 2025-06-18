import 'package:flutter/material.dart';
import 'package:studyswap/first_run.dart';
import 'package:studyswap/pages/onboarding/onboarding_page.dart';
import 'package:studyswap/pages/profile/profile_page.dart';
import 'home/home_page.dart';
import 'package:studyswap/pages/login.dart';
import 'package:studyswap/pages/register.dart';
import 'package:studyswap/pages/notifications_page.dart';
import 'package:is_first_run/is_first_run.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudySwap',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF082030)),
        useMaterial3: true,
        fontFamily: 'InstrumentSans',

        // Disable ripple and highlight globally
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      initialRoute: '/',
      routes: {
        '/onboarding': (context) => const OnboardingPage(),
        '/homescreen': (context) => const MyHomePage(title: "StudySwap"),
        '/notifications': (context) => const NotificationsPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/profile': (context) => const ProfilePage(hasAppBar: true,),
      },
      home: LandingPage(),
    );
  }
}
