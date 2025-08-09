import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studyswap/pages/profile/profile_page.dart';

class TutoringDetailPage extends StatefulWidget {
  final String subject;
  final String description;
  final List<bool> classes;
  final String userId;

  const TutoringDetailPage({
    super.key,
    required this.subject,
    required this.description,
    required this.classes,
    required this.userId,
  });

  @override
  State<TutoringDetailPage> createState() => _TutoringDetailPageState();
}

class _TutoringDetailPageState extends State<TutoringDetailPage> {
  String? username;
  String? school;
  bool isLoading = true;
  bool isExpanded = false;

  void toggleExpand() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUsername();
  }

  Future<void> fetchUsername() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userId)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        setState(() {
          username = (userDoc.data() as Map<String, dynamic>)['username'] ?? 'Unknown user';
          school = (userDoc.data() as Map<String, dynamic>)['school'] ?? 'Unknown school';
          isLoading = false;
        });
      } else {
        setState(() {
          username = 'User not found';
          school = 'School not found';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        username = 'Error loading user';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final List<String> ordinalYears = ['1st', '2nd', '3rd', '4th', '5th'];

    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.subject,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  isLoading ?
                  Text(
                    "....",
                    style: TextStyle(
                      fontSize: 18,
                      decoration: TextDecoration.underline,
                    ),
                  )
                      : Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage(isMine: false, userId: widget.userId),
                            ),
                          );
                        },
                        child: Text(
                          username!,
                          style: const TextStyle(
                            fontSize: 18,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Text(
                          "@${school!}",
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSecondaryContainer,
                          ),
                        ),
                      )
                    ],
                  ),
                  // const SizedBox(height: 16),
                  // IntrinsicWidth(
                  //   child: Container(
                  //     height: 24,
                  //     padding: const EdgeInsets.symmetric(horizontal: 24),
                  //     decoration: BoxDecoration(
                  //       color: theme.colorScheme.onSurface,
                  //       borderRadius: BorderRadius.circular(12),
                  //     ),
                  //     alignment: Alignment.center,
                  //     child: Text(
                  //       // Add currency (Euro by default) if a book is uploaded
                  //       'Undefined',
                  //       style: TextStyle(
                  //         color: theme.colorScheme.surface,
                  //         fontWeight: FontWeight.w700,
                  //         fontSize: 14,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Text("Year:"),
                      const SizedBox(width: 8),
                      Row(
                        children: List.generate(5, (index) {
                          final isSelected = widget.classes[index];
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
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.surface,
                            foregroundColor: theme.colorScheme.primary,
                            textStyle: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                color: theme.colorScheme.primary,
                                width: 2,
                              ),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {},
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.0),
                            child: Text('Contact owner', style: TextStyle(fontSize: 16)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // const SizedBox(height: 32),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //   ],
                  // ),
                  // Description
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Description",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextButton(
                              onPressed: toggleExpand,
                              child: Text(isExpanded ? 'View Less' : 'View All'),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        AnimatedCrossFade(
                          firstChild: Text(
                            widget.description,
                            style: const TextStyle(fontSize: 14),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          secondChild: Text(
                            widget.description,
                            style: const TextStyle(fontSize: 14),
                          ),
                          crossFadeState: isExpanded
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 300),
                        ),
                        SizedBox(height: 16),
                        Divider(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
