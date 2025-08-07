import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studyswap/providers/data_provider.dart';
import 'package:studyswap/providers/user_provider.dart';
import 'about.dart';
import 'tabs.dart';
import 'bookshop.dart';
import 'notes.dart';
import 'reviews.dart';
import 'tutoring.dart';

class ProfilePage extends ConsumerWidget {
  final bool isMine;
  final String userId;

  const ProfilePage({super.key, required this.isMine, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    if (userId.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("User ID is empty")),
      );
    }

    final currentUser = ref.watch(userProvider).value;

    final userDataAsync = ref.watch(dataProvider(userId));

    return userDataAsync.when(
      data: (userData) {
        if (userData == null) {
          return const Scaffold(
            body: Center(child: Text("User data not found.")),
          );
        }

        final String userEmail = userData['email'] as String? ?? "";
        final userDomain = userEmail.contains('@') ? userEmail.split('@')[1] : "";

        final circleColor = Color((userData["color"] ?? 0).toInt()).withAlpha(255);
        final textColor = ThemeData.estimateBrightnessForColor(circleColor) == Brightness.dark
            ? Colors.white
            : Colors.black;

        return DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: !isMine ? AppBar() : null,
            body: Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),

                    // MAIN PROFILE INFO
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: circleColor,
                                  ),
                                  child: Text(
                                    (userData['username'] as String?)?.isNotEmpty == true
                                        ? userData['username'][0].toUpperCase()
                                        : '?',
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userData['username'] ?? "Unknown User",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "@$userDomain",
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              width: 55,
                              height: 32,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.onPrimaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.star, size: 16, color: theme.colorScheme.primaryContainer),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${userData['stars'] ?? 0}",
                                    style: TextStyle(
                                      color: theme.colorScheme.surface,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        isMine
                            ? Column(
                          children: [
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: TextButton.icon(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/edit-profile');
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: theme.colorScheme.onSurface,
                                      backgroundColor: Colors.transparent,
                                      textStyle: theme.textTheme.bodyMedium?.copyWith(
                                        fontSize: 14,
                                        color: theme.colorScheme.onSurface,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          color: theme.colorScheme.secondary,
                                          width: 0.5,
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    ),
                                    icon: Icon(
                                      Icons.edit,
                                      color: theme.colorScheme.onSurface,
                                    ),
                                    label: const Text("Edit profile"),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                TextButton.icon(
                                  onPressed: () async {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text("Log out?"),
                                        content: const Text("Your session will expire and you'll be sent back to the login page"),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text("No"),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              await FirebaseAuth.instance.signOut();
                                              Navigator.pushReplacementNamed(context, '/login');
                                            },
                                            child: const Text("Yes"),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: theme.colorScheme.onSurface,
                                    backgroundColor: Colors.transparent,
                                    textStyle: theme.textTheme.bodyMedium?.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: theme.colorScheme.onSurface,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: theme.colorScheme.secondary,
                                        width: 0.5,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  ),
                                  icon: Icon(
                                    Icons.logout,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                  label: const Text("Log Out"),
                                ),
                              ],
                            ),
                          ],
                        )
                            : const SizedBox.shrink(),

                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return About(user: userData["email"]);
                            }));
                          },
                          child: Text(
                            userData["aboutme"] ?? "",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // TABS
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: theme.colorScheme.secondary,
                          width: 0.25,
                        ),
                      ),
                    ),
                    child: const Tabs(),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        SingleChildScrollView(child: Notes(userId)),
                        SingleChildScrollView(child: Books(userId: userId)),
                        SingleChildScrollView(child: Tutoring(userId: userId)),
                        SingleChildScrollView(
                          child: Reviews(
                            stars: (userData['stars']?.toDouble()) ?? 0,
                            profile: "",
                            isMine: isMine,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
    );
  }
}
