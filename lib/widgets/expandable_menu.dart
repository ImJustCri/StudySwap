import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class ExpandableFabMenu extends StatelessWidget {
  const ExpandableFabMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      backgroundColor: theme.colorScheme.primary,
      activeBackgroundColor: theme.colorScheme.secondary,
      foregroundColor: theme.colorScheme.surface,
      activeForegroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      animationDuration: const Duration(milliseconds: 250),
      children: [
        SpeedDialChild(
          child: Icon(Icons.note, color: theme.colorScheme.surface),
          label: 'Note',
          backgroundColor: theme.colorScheme.primary,
          labelStyle: const TextStyle(fontSize: 16),
          onTap: () => Navigator.pushNamed(context, '/notes-upload'),
        ),
        SpeedDialChild(
          child: Icon(Icons.book, color: theme.colorScheme.surface),
          label: 'Book',
          backgroundColor: theme.colorScheme.primary,
          labelStyle: const TextStyle(fontSize: 16),
          onTap: () => Navigator.pushNamed(context, '/books-upload'),
        ),
        SpeedDialChild(
          child: Icon(Icons.school, color: theme.colorScheme.surface),
          label: 'Tutoring',
          backgroundColor: theme.colorScheme.primary,
          labelStyle: const TextStyle(fontSize: 16),
          onTap: () => Navigator.pushNamed(context, '/tutoring-upload'),
        ),
      ],
    );
  }
}
