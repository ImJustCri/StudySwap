import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:studyswap/home/home_page.dart';
import 'package:studyswap/pages/onboarding/onboarding_page.dart';
import 'package:studyswap/services/traslation_manager.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  Future<String> _getInitialRoute() async {
    // Controllo autenticazione
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return '/onboarding';

    await LocaleManager.loadLanguage(user.uid);
    return '/homescreen';
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<String>(
      future: _getInitialRoute(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else {
          // Invece di fare pushReplacement, ritorno direttamente la pagina giusta
          if (snapshot.data == '/onboarding') {
            return const OnboardingPage();
          } else {
            return const MyHomePage(title: "StudySwap");
          }
        }
      },
    );
  }
}
