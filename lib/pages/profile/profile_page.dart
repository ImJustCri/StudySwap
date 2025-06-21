import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'about.dart';
import 'tabs.dart';
import 'bookshop.dart';
import 'notes.dart';
import 'reviews.dart';
import 'tutoring.dart';

class ProfilePage extends StatelessWidget {
  final bool hasAppBar;
  const ProfilePage({super.key, required this.hasAppBar});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentUser = FirebaseAuth.instance.currentUser!;
    final db = FirebaseFirestore.instance;

    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: db.collection("Users").doc(currentUser.email).snapshots(),
          builder: (context, snapshot) {
          // Get user data
            if (snapshot.hasData) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;

              return DefaultTabController(
                length: 4,
                child: Scaffold(
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
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
                                      color: Color((userData["color"]).toInt()).withValues(alpha: 1.0),
                                    ),
                                    child: Text(
                                      userData['username'][0].toUpperCase(),
                                      style: TextStyle(
                                        color: theme.colorScheme.surface,
                                        fontSize: 24,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        userData['username'],
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        "@${currentUser.email?.split("@")[1]}",
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                width: 55,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.onSurface,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.star, size: 16, color: theme.colorScheme.surface),
                                    const SizedBox(width: 4),
                                    Text(
                                      "${userData['stars']}",
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
                                  Icons.logout,
                                  color: theme.colorScheme.onSurface,
                                ),
                                label: const Text("Log Out"),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return About(userData: userData);
                              }));
                            },
                            child: Text(
                              userData["aboutme"], // Text
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Tabs(),
                          SizedBox(
                            height: 400,
                            child: TabBarView(
                              children: [
                                const Notes(),
                                const Books(),
                                const Tutoring(),
                                SingleChildScrollView(
                                  child: Reviews(stars: userData['stars']),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}" ),
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
      )
    );
  }
}