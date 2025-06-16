import 'package:flutter/material.dart';
import 'package:studyswap/widgets/notifications_tile.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  // For now, notifications are hardcoded
  // TODO: Implement real notifications loading from device
  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        "title": "Test",
        "subtitle": "Notification info",
        "date": "April 17",
        "isUnread": true,
      },
      {
        "title": "Welcome to StudySwap",
        "subtitle": "Start browsing for content you need",
        "date": "April 15",
        "isUnread": false,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notifications",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 22,
          ),
        ),
        leading: BackButton(),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.only(top: 24),
        itemCount: notifications.length,
        separatorBuilder: (context, index) => Divider(height: 0, color: Colors.blue[50]),
        itemBuilder: (context, index) {
          final notif = notifications[index];
          return NotificationTile(
            title: notif["title"] as String,
            subtitle: notif["subtitle"] as String,
            date: notif["date"] as String,
            isUnread: notif["isUnread"] as bool,
          );
        },
      ),
    );
  }
}
