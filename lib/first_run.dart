import 'package:flutter/material.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:studyswap/misc/resources.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  Future<bool> _checkFirstRun() => IsFirstRun.isFirstRun();

  Future<String> _getInitialRoute() async {
    // Check first run
    final isFirstRun = await _checkFirstRun();
    if (isFirstRun) return '/onboarding';

    // Check authentication
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return '/login';

    // If authenticated, go to home
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
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed(snapshot.data!);
          });

          // Optional: splash image while redirecting
          return Center(
            child: Image.asset(R.imageOnboarding4, width: 128),
          );
        }
      },
    );
  }
}
