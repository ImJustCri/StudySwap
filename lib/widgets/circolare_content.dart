import 'package:flutter/material.dart';

class CircolareContent extends StatelessWidget {
  final String date;
  final String title;

  const CircolareContent({
    super.key,
    required this.date,
    required this.title,
  });

  String get processedTitle {
    if (title.isEmpty) return '';
    final dotIndex = title.indexOf('.');
    if (dotIndex == -1 || dotIndex == title.length - 1) {
      return title.trim();
    }
    return title.substring(dotIndex + 1).trim();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.secondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              Flexible(
                child: Text(
                  processedTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
