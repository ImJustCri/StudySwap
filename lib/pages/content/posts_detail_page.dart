import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studyswap/pages/profile/profile_page.dart';
import '../../providers/notes_provider.dart';
import '../../services/posts_manager.dart';
import '../bought/transaction.dart';
import '../edit/edit_books_details.dart';
import '../edit/edit_notes_details.dart';
import 'more_from_user.dart';

class PostDetailsPage extends ConsumerStatefulWidget {
  final String title;
  final String subject;
  final String userId;
  final String id;
  final int price;
  final String description;
  final String imageUrl;
  final String contactPlatform;
  final String contactHandle;
  final bool isOfUser;

  // Optional fields for books
  final String? isbn;
  final int? year;
  final String? currency;

  const PostDetailsPage({
    super.key,
    required this.title,
    required this.subject,
    required this.price,
    required this.userId,
    required this.description,
    required this.imageUrl,
    required this.isOfUser,
    required this.id,
    required this.contactHandle,
    required this.contactPlatform,

    // Optional fields for books
    this.isbn,
    this.year,
    this.currency,
  });

  @override
  ConsumerState<PostDetailsPage> createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends ConsumerState<PostDetailsPage> {
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
    final boughtNotesAsync = ref.watch(boughtNotesProvider);

    bool isBought = false;

    boughtNotesAsync.when(
        data: (boughtNotesList) {
          isBought = boughtNotesList.any((note) => note['note_id'] == widget.id);
        },
        loading: () {
          isBought = false;
        },
        error: (error, stack) {
          isBought = false;
        }
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        actions: [
          if (widget.isOfUser)
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    widget.isbn == null
                        ? Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditNotesPage(
                          noteId: widget.id,
                          title: widget.title,
                          subject: widget.subject,
                          userId: widget.userId,
                          price: widget.price,
                          description: widget.description,
                          imageUrl: widget.imageUrl,
                        ),
                      ),
                    )
                        : Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditBooksPage(
                          bookId: widget.id,
                          title: widget.title,
                          subject: widget.subject,
                          userId: widget.userId,
                          price: widget.price,
                          description: widget.description,
                          imageUrl: widget.imageUrl,
                          isbn: widget.isbn,
                          year: widget.year,
                          currency: widget.currency,
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirm Delete'),
                          content: const Text('Are you sure you want to delete this post?'),
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
                                widget.isbn != null
                                    ? postsManager.deleteBook(widget.id)
                                : postsManager.deleteNote(widget.id);

                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                              child: const Text('Yes'),
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
            )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 296,
              width: double.infinity,
              color: theme.colorScheme.secondaryContainer,
              child: widget.imageUrl.isNotEmpty
                  ? Image.network(
                widget.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 296,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      Icons.broken_image,
                      size: 80,
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                  );
                },
              )
                  : Center(
                child: Icon(
                  Icons.note,
                  size: 80,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
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
                      : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfilePage(userId: widget.userId),
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
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Text(
                            "@${school ?? ''}",
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSecondaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  IntrinsicWidth(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurface,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${widget.price}${widget.currency ?? ''}',
                        style: TextStyle(
                          color: theme.colorScheme.surface,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  if (!widget.isOfUser)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (widget.isbn == null || widget.isbn!.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.shopping_cart_rounded),
                          onPressed: isBought ? null : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TransactionPage(
                                  noteId: widget.id,
                                  price: widget.price,
                                  title: widget.title,
                                  subject: widget.subject,
                                  sellerId: widget.userId,
                                ),
                              ),
                            );
                          },

                          label: isBought ? const Text(
                            'Note already bought',
                            style: TextStyle(fontSize: 16),
                          ) : const Text(
                            'Buy this note',
                            style: TextStyle(fontSize: 16),
                          ),
                          style: isBought
                              ? ElevatedButton.styleFrom(
                            backgroundColor: theme.disabledColor,
                          )
                              : null,
                        ),
                      ),

                      SizedBox(height: 16),
                      ElevatedButton.icon(
                        icon: Icon(Icons.messenger_outline_rounded),
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
                                          const SnackBar(content: Text('Copied to clipboard')),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    child: const Text('Close'),
                                    onPressed: () => Navigator.of(context).pop(),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        label: Text(
                          'Contact owner',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Subject",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 24),
                      Flexible(
                        child: Text(
                          widget.subject,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (widget.year != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Year of Publication",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 24),
                          Flexible(
                            child: Text(
                              "${widget.year}",
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (widget.isbn != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "ISBN",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 24),
                          Flexible(
                            child: Text(
                              widget.isbn!,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

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
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                  MoreFromUser(
                    isBook: widget.isbn != null ? true : false,
                    userId: widget.userId,
                    username: username,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}