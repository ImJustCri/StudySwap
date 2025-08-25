import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studyswap/services/coins_manager.dart';
import 'package:studyswap/services/traslation_manager.dart';
class ReviewBottomSheet extends StatefulWidget {
  final int initialRating;
  final String profile;

  const ReviewBottomSheet({super.key, this.initialRating = 0, required this.profile});

  @override
  State<ReviewBottomSheet> createState() => _ReviewBottomSheetState();
}

class _ReviewBottomSheetState extends State<ReviewBottomSheet> {
  late int _selectedRating;
  final TextEditingController _reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedRating = widget.initialRating;
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Widget _buildStar(int index, Color color) {

    return IconButton(
      icon: Icon(
        index <= _selectedRating ? Icons.star : Icons.star_border,
        color: color,
        size: 32,
      ),
      onPressed: () {
        setState(() {
          _selectedRating = index;
        });
      },
    );
  }

  void submit(String revieweeUsername) async {
    final coinsManager = CoinsManager();
    final db = FirebaseFirestore.instance;
    final currentUser = FirebaseAuth.instance.currentUser!.uid;

    final reviewText = _reviewController.text.trim();
    if (_selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(Translation.of(context)!.translate("profile.writeReview.message1"))),
      );
      return;
    }
    if (reviewText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text(Translation.of(context)!.translate("profile.writeReview.message2"))),
      );
      return;
    }

    final reviewerId = currentUser;

    // Reference to the review document in Firestore
    final reviewDocRef = db
        .collection("Users")
        .doc(widget.profile)
        .collection("Reviews")
        .doc(currentUser);

    // Check if the review document already exists
    final docSnapshot = await reviewDocRef.get();

    if (!docSnapshot.exists) {
      await coinsManager.addCoins(currentUser, 20);
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(Translation.of(context)!.translate("profile.writeReview.titleCongratulation")),
            content: Text(Translation.of(context)!.translate("profile.writeReview.bodyCongratulation")),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(Translation.of(context)!.translate("profile.writeReview.buttonCongratulation")),
              ),
            ],
          );
        },
      );
    }


    final reviewData = {
      "reviewerId": reviewerId,
      "revieweeUsername": revieweeUsername,
      "rating": _selectedRating,
      "review": reviewText,
      "upload_time": FieldValue.serverTimestamp(),
    };

    await reviewDocRef.set(reviewData);

    Navigator.of(context).pop({
      'rating': _selectedRating,
      'review': reviewText,
    });
  }


  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final theme = Theme.of(context);
    final db = FirebaseFirestore.instance;

    return StreamBuilder<DocumentSnapshot>(
      stream: db.collection("Users").doc(widget.profile).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(Translation.of(context)!.translate("profile.writeReview.error")));
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(child: CircularProgressIndicator());
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;

        return Padding(
          padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: bottomInset + 24),
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 16,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    Translation.of(context)!.translate("profile.writeReview.titlePage")+'${userData['username'] ?? widget.profile}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5,
                        (index) => _buildStar(index + 1, theme.colorScheme.secondary),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _reviewController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: Translation.of(context)!.translate("profile.writeReview.box"),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        side: BorderSide(
                          width: 0.5,
                          color: theme.colorScheme.secondary,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        foregroundColor: theme.colorScheme.secondary,
                        textStyle: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(Translation.of(context)!.translate("profile.writeReview.cancelButton")),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.onSurface,
                        foregroundColor: theme.colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        textStyle: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {
                        submit(userData['username']);
                      },
                      child: Text(Translation.of(context)!.translate("profile.writeReview.submitButton")),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
