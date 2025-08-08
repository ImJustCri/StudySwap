import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studyswap/providers/circolari_feed_provider.dart';
import '../main_top_bar.dart';
import '../pages/settings/favorite_subjects.dart';
import '../providers/notes_provider.dart';
import '../widgets/expandable_menu.dart';
import 'home_page_content.dart';
import 'package:studyswap/pages/search_page.dart';
import 'package:studyswap/pages/profile/profile_page.dart';
import 'package:studyswap/pages/exchange_page.dart';
import '../bottom_nav_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  int _selectedIndex = 0;
  final currentUser = FirebaseAuth.instance.currentUser;

  Future<void> _handleRefresh() async {
    ref.invalidate(userDataProvider);
    ref.invalidate(last20NotesProvider);
    ref.invalidate(notesProvider);
    ref.invalidate(suggestedNotesProvider);
    ref.invalidate(circolariFeedProvider);

    await Future.delayed(const Duration(milliseconds: 300));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      RefreshIndicator(
        onRefresh: _handleRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: const HomePageContent(),
        ),
      ),
      const SearchPage(),
      const ExchangePage(),
      ProfilePage(isMine: true, userId: currentUser!.uid),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      floatingActionButton:
      (_selectedIndex == 0 || _selectedIndex == 2) ? ExpandableFabMenu() : null,
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
