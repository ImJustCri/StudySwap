import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../main_top_bar.dart';
import '../widgets/expandable_menu.dart';
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
  final currentUser = FirebaseAuth.instance.currentUser;

  Future<void> _handleRefresh() async {
    await Future.delayed(Duration(seconds: 1));

    setState(() {
    // TODO
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> get _pages => [
    RefreshIndicator(
      onRefresh: _handleRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: const HomePageContent(),
      ),
    ),

    const SearchPage(),
    const ExchangePage(),
    ProfilePage(isMine: true, user: currentUser),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(),
      body: _pages[_selectedIndex],
      floatingActionButton: _selectedIndex == 0 ? ExpandableFabMenu() : null,
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}