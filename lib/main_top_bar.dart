import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studyswap/coins_page.dart';
import 'package:studyswap/misc/resources.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final db = FirebaseFirestore.instance;
    final currentUser = FirebaseAuth.instance.currentUser!;

    return AppBar(
        automaticallyImplyLeading: false,
        title: Image.asset(
          R.logo,
          height: 32,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(64.0),
              color: theme.colorScheme.onSurface,
            ),
            child: StreamBuilder(
            stream: db.collection("Users").doc(currentUser.email).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final coins = snapshot.data!.get("coins");

                return TextButton.icon(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CoinsPage("$coins")));
                  },
                  icon: Icon(
                    Icons.monetization_on,
                    color: theme.colorScheme.surface,
                    size: 24,
                  ),
                  label: Text(
                    "$coins",
                    style: TextStyle(
                      color: theme.colorScheme.surface,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(8.0),
                    alignment: Alignment.center,
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.monetization_on, color: theme.colorScheme.surface,),
                    Text(
                      "Loading",
                      style: TextStyle(
                        color: theme.colorScheme.surface,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            }
            )
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            color: theme.colorScheme.onSurface,
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
        ],
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 64,
      );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
