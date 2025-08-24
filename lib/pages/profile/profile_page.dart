import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studyswap/providers/average_rating_provider.dart';
import 'package:studyswap/providers/data_provider.dart';
import 'package:studyswap/providers/user_provider.dart';
import 'about.dart';
import 'tabs.dart';
import 'bookshop.dart';
import 'notes.dart';
import 'reviews.dart';
import 'tutoring.dart';
import 'package:studyswap/services/traslation_manager.dart';
class ProfilePage extends ConsumerStatefulWidget {
  final String userId;
  final bool fromNavigation;

  const ProfilePage({
    super.key,
    required this.userId,
    this.fromNavigation = false,
  });

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentUser = ref.watch(userProvider).value;
    final averageReviewAsync = ref.watch(averageRatingProvider(widget.userId));
    final userDataAsync = ref.watch(dataProvider(widget.userId));

    final bool isMine = currentUser?.uid == widget.userId;

    if (widget.userId.isEmpty) {
      return  Scaffold(
        body: Center(child: Text(Translation.of(context)!.translate("profile.errorEmptyUser"))),
      );
    }

    return userDataAsync.when(
      data: (userData) {
        if (userData == null) {
          return Scaffold(
            body: Center(child: Text(Translation.of(context)!.translate("profile.userNotFound"))),
          );
        }

        final String userEmail = userData['email'] as String? ?? "";
        final userDomain = userEmail.contains('@') ? userEmail.split('@')[1] : "";

        return DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: !widget.fromNavigation ? AppBar() : null,
            body: Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                        userData['image'] ??
                                            "https://mrskvszubvnunoowjeth.supabase.co/storage/v1/object/public/pfp/default.png",
                                      ),
                                      fit: BoxFit.cover,
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
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.onPrimaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.star, size: 16, color: theme.colorScheme.primaryContainer),
                                  const SizedBox(width: 4),
                                  averageReviewAsync.when(
                                    data: (average) => Text(
                                      average != null ? average.toStringAsFixed(1) : "0",
                                      style: TextStyle(
                                        color: theme.colorScheme.surface,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    loading: () => SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: theme.colorScheme.primaryContainer,
                                      ),
                                    ),
                                    error: (_, __) => Text(
                                      "0",
                                      style: TextStyle(
                                        color: theme.colorScheme.surface,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
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
                                    label: Text(Translation.of(context)!.translate("profile.buttonEdit")),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                TextButton.icon(
                                  onPressed: () async {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title:  Text(Translation.of(context)!.translate("profile.logOutTitle")),
                                        content:  Text(Translation.of(context)!.translate("profile.logOutBody")),
                                        actions: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: TextButton(
                                                  onPressed: () => Navigator.pop(context),
                                                  child: const Text("No"),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: TextButton(
                                                  onPressed: () async {
                                                    await FirebaseAuth.instance.signOut();
                                                    Navigator.pushReplacementNamed(context, '/login');
                                                  },
                                                  child: Text(Translation.of(context)!.translate("profile.buttonYes")),
                                                ),
                                              ),
                                            ],
                                          )
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
                                  label: Text(Translation.of(context)!.translate("profile.buttonLogOut")),
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
                              return About(user: widget.userId);
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
                        SingleChildScrollView(child: Notes(widget.userId)),
                        SingleChildScrollView(child: Books(userId: widget.userId)),
                        SingleChildScrollView(child: Tutoring(userId: widget.userId)),
                        SingleChildScrollView(
                          child: Reviews(
                            stars: averageReviewAsync.asData?.value ?? 0,
                            userId: widget.userId,
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
