import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:studyswap/pages/profile/profile_page.dart';
import 'package:studyswap/services/posts_manager.dart';
import 'package:studyswap/services/traslation_manager.dart';
import '../edit/edit_tutoring_details.dart';

class TutoringDetailPage extends StatefulWidget {
  final String tutoringId;
  final String subject;
  final String description;
  final List<bool> classes;
  final String userId;
  final num hours;
  final String mode;
  final String contactHandle;
  final String contactPlatform;
  final bool isOfUser;

  const TutoringDetailPage({
    super.key,
    required this.tutoringId,
    required this.subject,
    required this.description,
    required this.classes,
    required this.userId,
    required this.isOfUser,
    required this.hours,
    required this.mode,
    required this.contactHandle,
    required this.contactPlatform,
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
    final isOfUser = widget.isOfUser;

    return Scaffold(
      appBar: AppBar(
        title:  Text(Translation.of(context)!.translate("postDetail.titlePage")),
        actions: [
          if (isOfUser)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditTutoringDetails(
                          subject: widget.subject,
                          description: widget.description,
                          classes: widget.classes,
                          userId: widget.userId,
                          tutoringId: widget.tutoringId,
                          mode: widget.mode,
                          hours: widget.hours.toDouble(),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(Translation.of(context)!.translate("postDetail.titleDelete")),
                          content: Text(Translation.of(context)!.translate("postDetail.bodyDelete")),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: const Text('No'),
                            ),
                            TextButton(
                              onPressed: () {
                                final postsManager = PostsManager();
                                postsManager.deleteTutoring(widget.tutoringId);
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                              child: Text(Translation.of(context)!.translate("postDetail.buttonYesDelete")),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.delete_rounded,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
        ],
      ),
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
                  isLoading
                      ? Text(
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
                              builder: (context) =>
                                  ProfilePage(userId: widget.userId),
                            ),
                          );
                        },
                        child: Text(
                          username ?? '',
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: Text(
                          "@${school ?? ''}",
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSecondaryContainer,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Text(Translation.of(context)!.translate("postDetail.yearT")),
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? theme.colorScheme.secondary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                yearText,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected
                                      ? theme.colorScheme.surface
                                      : theme.textTheme.bodyMedium?.color
                                      ?.withAlpha(153), // ~60%
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (!widget.isOfUser)
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
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
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(widget.contactPlatform),
                                  content: Row(
                                    children: [
                                      Expanded(
                                        child: SelectableText(widget.contactHandle, style: const TextStyle(fontSize: 16)),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.copy),
                                        tooltip: 'Copy to clipboard',
                                        onPressed: () {
                                          Clipboard.setData(ClipboardData(text: widget.contactHandle));
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text(Translation.of(context)!.translate("postDetail.copyName"))),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text(Translation.of(context)!.translate("postDetail.copyNameButton")),
                                      onPressed: () => Navigator.of(context).pop(),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.messenger_outline_rounded),
                          label: Text(Translation.of(context)!.translate("postDetail.contact"),
                              style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       Text(
                        Translation.of(context)!.translate("tutoring.mode.title"),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 24),
                      Flexible(
                        child: Text(
                          Translation.of(context)!.translate("tutoring.mode.${widget.mode}"),
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Translation.of(context)!.translate("tutoring.labelHours"),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 24),
                      Flexible(
                        child: Text(
                          "${widget.hours}",
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              Translation.of(context)!.translate("labelDescription"),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextButton(
                              onPressed: toggleExpand,
                              child: Text(isExpanded ? Translation.of(context)!.translate("postDetail.viewLess") : Translation.of(context)!.translate("postDetail.viewAll")),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
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
                        const SizedBox(height: 16),
                        const Divider(),
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
