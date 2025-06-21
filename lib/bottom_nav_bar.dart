import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentUser = FirebaseAuth.instance.currentUser!;
    final db = FirebaseFirestore.instance;
    return StreamBuilder<DocumentSnapshot>(
      stream: db.collection("Users").doc(currentUser.email).snapshots(),
      builder: (context, snapshot) {
        String displayLetter = "S";
        Color baseColor = Colors.black;

        if (snapshot.hasData && snapshot.data != null) {
          final data = snapshot.data!.data() as Map<String, dynamic>?;

          if (data != null) {
            if (data['username'] is String && data['username'].isNotEmpty) {
              displayLetter = data['username'][0].toUpperCase();
            }
            if (data['color'] is int) {
              // Convert int color to Color object
              baseColor = Color(data['color']);
            }
          }
        }
        
        return NavigationBarTheme(
          data: NavigationBarThemeData(
            labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                );
              }
              return TextStyle(
                fontSize: 12,
                color: theme.colorScheme.secondary,
              );
            }),
            indicatorColor: Colors.transparent,
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: theme.colorScheme.secondary,
                  width: 0.25,
                ),
              ),
            ),
            child: NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: onItemTapped,
              backgroundColor: theme.colorScheme.surface,
              destinations: <NavigationDestination>[
                const NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.search_outlined),
                  selectedIcon: Icon(Icons.search),
                  label: 'Search',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.compare_arrows_rounded),
                  selectedIcon: Icon(Icons.compare_arrows_rounded),
                  label: 'Exchange',
                ),
                NavigationDestination(
                  icon: Container(
                    alignment: Alignment.center,
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: baseColor.withValues(alpha: .5),
                    ),
                    child: Text(
                      displayLetter,
                      style: TextStyle(
                        color: theme.colorScheme.surface,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  selectedIcon: Container(
                    alignment: Alignment.center,
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: baseColor.withValues(alpha: 1),
                    ),
                    child: Text(
                      displayLetter,
                      style: TextStyle(
                        color: theme.colorScheme.surface,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  label: 'You',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
