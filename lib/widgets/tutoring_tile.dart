import 'package:flutter/material.dart';

import '../pages/content/tutoring_detail_page.dart';

class TutoringTile extends StatelessWidget {
  final String title;
  final List<bool> isYearSelected;
  final String description;
  final String userId;

  const TutoringTile({
    super.key,
    required this.title,
    required this.isYearSelected,
    required this.description,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<String> ordinalYears = ['1st', '2nd', '3rd', '4th', '5th'];

    Widget buildYearChips() {
      return Row(
        children: [
          const Text("Year:"),
          const SizedBox(width: 8),
          Row(
            children: List.generate(5, (index) {
              final isSelected = isYearSelected[index];
              final yearText = ordinalYears[index];

              return Padding(
                padding: EdgeInsets.only(
                  right: index != 4 ? 8.0 : 0,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? theme.colorScheme.secondary : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    yearText,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? theme.colorScheme.surface
                          : theme.textTheme.bodyMedium?.color?.withAlpha(153), // ~60%
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      );
    }

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TutoringDetailPage(
              subject: title,
              description: description,
              classes: isYearSelected,
              userId: userId,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            buildYearChips(),
          ],
        ),
      ),
    );
  }
}