import 'package:flutter/material.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:studyswap/misc/resources.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  Future<bool> _checkFirstRun() => IsFirstRun.isFirstRun();

  void _reset() async {
    await IsFirstRun.reset();
    _checkFirstRun();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkFirstRun(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (snapshot.data == true) {
              Navigator.of(context).pushReplacementNamed('/onboarding');
            } else {
              Navigator.of(context).pushReplacementNamed('/homescreen');
            }
          });

          return Center(
            child: Image.asset(R.imageOnboarding4, width: 128,),
          );
        }
      },
    );
  }
}

