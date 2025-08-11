import 'package:flutter/material.dart';

class NotificationTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String date;
  final bool isUnread;

  const NotificationTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.date,
    this.isUnread = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: isUnread ? theme.colorScheme.secondaryContainer : Colors.transparent,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),
          Text(
            date,
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSecondaryContainer,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}
