import 'package:flutter/material.dart';

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
    // TODO: Add more subjects and fetch them from Firebase
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchBar(
            hintText: "Search for content",
            leading: const Icon(Icons.search),
            padding: const WidgetStatePropertyAll<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: 16.0),
            ),
            backgroundColor: WidgetStateProperty.all(theme.colorScheme.surface),
            elevation: WidgetStateProperty.all(0),
            side: WidgetStateProperty.all(BorderSide(
              color: theme.colorScheme.secondaryFixedDim,
              width: 1,
            )),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Subjects",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text("View All"),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              itemCount: subjects.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) => Material(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    // TODO: Navigate to the corresponding section
                  },
                  hoverColor: theme.colorScheme.secondaryFixed,
                  splashColor: theme.colorScheme.secondaryFixed,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        subjects[index],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
