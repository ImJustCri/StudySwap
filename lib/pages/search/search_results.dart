import 'package:flutter/material.dart';
import 'package:studyswap/pages/search/results/books_results.dart';
import 'package:studyswap/pages/search/results/notes_results.dart';
import 'package:studyswap/pages/search/results/profile_results.dart';
import 'package:studyswap/pages/search/results_tabs.dart';

class SearchResults extends StatefulWidget {
  const SearchResults({super.key});

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults>
    with SingleTickerProviderStateMixin {
  String _searchText = "";
  late final TabController _tabController;

  final List<Map<String, String>> users = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0, bottom: 0),
            child: TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Search for notes, books, profiles...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                filled: true,
                fillColor: theme.colorScheme.surface,
              ),
              onChanged: (value) {
                setState(() {
                  _searchText = value.trim();
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ResultsTabs(controller: _tabController),
          ),

          const Divider(height: 0.5),
          const SizedBox(height: 16),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                NotesResults(searchQuery: _searchText),
                BooksResults(searchQuery: _searchText),
                ProfileResults(searchQuery: _searchText),
              ],
            ),
          ),
        ],
      ),
    );

  }
}
