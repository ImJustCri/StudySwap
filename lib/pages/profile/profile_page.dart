import 'package:flutter/material.dart';
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
    final defaultStyle = Theme.of(context).textTheme.bodyMedium!;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: hasAppBar
            ? AppBar(
          title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.w500)),
        )
            : null,
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
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage('https://art.pixilart.com/62882e5f026c03e.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "<Account Name>",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "<email>@<school>.edu.it",
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
                        color: Theme.of(context).colorScheme.onSurface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star, size: 16, color: Theme.of(context).colorScheme.surface),
                          const SizedBox(width: 4),
                          Text(
                            '4.5',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.surface,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Tabs(), // TabBar here
                SizedBox(
                  height: 400,
                  child: const TabBarView(
                    children: [
                      Notes(),
                      Books(),
                      Tutoring(),
                      Reviews(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
