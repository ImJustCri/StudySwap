import 'package:flutter/material.dart';
import 'search_results.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  final List<String> subjects = const [
    "Information Technology",
    "Mathematics",
    "Telecommunications",
    "History",
    "Physical Education",
    "Italian Literature",
    "Systems and Networking",
    "English Language",
    "TPSIT",
  ];

  final Map<String, IconData> subjectIcons = const {
    "Information Technology": Icons.computer,
    "Mathematics": Icons.calculate,
    "Telecommunications": Icons.wifi,
    "History": Icons.history_edu,
    "Physical Education": Icons.sports_soccer,
    "Italian Literature": Icons.menu_book,
    "Systems and Networking": Icons.settings_input_component,
    "English Language": Icons.language,
    "TPSIT": Icons.code,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const SearchResults()),
                // );
              },
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search for notes or profiles",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                  ),
                  enabled: false,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Subjects",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                itemCount: subjects.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final subject = subjects[index];
                  final icon = subjectIcons[subject] ?? Icons.book;

                  return Material(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        // TODO: Navigate to related section
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                        child: Row(
                          children: [
                            Icon(
                              icon,
                              color: theme.colorScheme.onPrimaryContainer,
                              size: 24,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                subject,
                                style: TextStyle(
                                  color: theme.colorScheme.onPrimaryContainer,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
