import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studyswap/providers/data_provider.dart';
import 'package:studyswap/providers/user_provider.dart';
import '../../widgets/reviews/review_average_calculator.dart';
import 'about.dart';
import 'tabs.dart';
import 'bookshop.dart';
import 'notes.dart';
import 'reviews.dart';
import 'tutoring.dart';

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
  double? averageStars;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadAverageStars();
  }

  Future<void> _loadAverageStars() async {
    try {
      final calculator = ReviewsAverageCalculator(userId: widget.userId);
      final avg = await calculator.calculateAverage();
      setState(() {
        averageStars = avg;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentUser = ref.watch(userProvider).value;
    final userDataAsync = ref.watch(dataProvider(widget.userId));

    final bool isMine = currentUser?.uid == widget.userId;

    if (widget.userId.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("User ID is empty")),
      );
    }

    return userDataAsync.when(
      data: (userData) {
        if (userData == null) {
          return const Scaffold(
            body: Center(child: Text("User data not found.")),
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
                                  if (isLoading)
                                    SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: theme.colorScheme.primaryContainer,
                                      ),
                                    )
                                  else if (error != null)
                                    Text(
                                      "0",
                                      style: TextStyle(
                                        color: theme.colorScheme.surface,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  else
                                    Text(
                                      averageStars != null ? averageStars!.toStringAsFixed(1) : "0",
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
                                                  child: const Text("Yes"),
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
                            stars: averageStars ?? 0,
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
