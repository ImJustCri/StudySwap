import 'package:flutter/material.dart';
import 'package:studyswap/pages/profile/profile_page.dart';
import 'home/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudySwap',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
        useMaterial3: true,
        fontFamily: 'InstrumentSans',

        // Disable ripple and highlight globally
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      initialRoute: '/',
      routes: {
        '/profile': (context) => const ProfilePage(hasAppBar: true,),
      },
      home: const MyHomePage(title: 'StudySwap'),
    );
  }
}
