import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../main_top_bar.dart';
import 'home_page_content.dart';
import 'package:studyswap/pages/search_page.dart';
import 'package:studyswap/pages/profile/profile_page.dart';
import 'package:studyswap/pages/exchange_page.dart';
import '../bottom_nav_bar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final currentUser = FirebaseAuth.instance.currentUser!.email;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Fixed: Convert to getter to access instance members
  List<Widget> get _pages => [
    const HomePageContent(),
    const SearchPage(),
    const ExchangePage(),
    ProfilePage(isMine: true, user: currentUser), // Now accesses instance variable
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(),
      body: _pages[_selectedIndex],
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
        onPressed: () {},
        tooltip: 'Upload something',
        child: const Icon(Icons.add_circle_outlined),
      )
          : null,
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}