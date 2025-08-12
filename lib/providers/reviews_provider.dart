import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userReviewsProvider = StreamProvider.family<List<Map<String, dynamic>>, String>((ref, userId) {
  final collectionRef = FirebaseFirestore.instance
      .collection('Users')
      .doc(userId)
      .collection('Reviews');

  return collectionRef.snapshots().map(
        (querySnapshot) => querySnapshot.docs.map(
          (doc) => doc.data(),
    ).toList(),
  );
});

// Provider for the amount of reviews a user has
final userReviewsCountProvider = StreamProvider.family<int, String>((ref, userId) {
  final collectionRef = FirebaseFirestore.instance
      .collection('Users')
      .doc(userId)
      .collection('Reviews');

  return collectionRef.snapshots().map(
        (querySnapshot) => querySnapshot.docs.length,
  );
});


// Provider for the amount of reviews for each rating
final userReviewsRatingCountProvider = StreamProvider.family<List<int>, String>((ref, userId) {
  final collectionRef = FirebaseFirestore.instance
      .collection('Users')
      .doc(userId)
      .collection('Reviews');

  return collectionRef.snapshots().map((querySnapshot) {
    // Initialize a list with 5 zeros to count ratings from 5 down to 1 star
    final counts = List<int>.filled(5, 0);

    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      final rating = data['rating'];

      // Check that the rating is an int within 1 to 5
      if (rating is int && rating >= 1 && rating <= 5) {
        // counts[0] is for 5-star, so index = 5 - rating
        counts[5 - rating] += 1;
      }
    }

    return counts;
  });
});

