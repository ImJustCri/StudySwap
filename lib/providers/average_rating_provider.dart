import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final averageRatingProvider = FutureProvider.family<double?, String>((ref, userId) async {
  final reviewsCollection = FirebaseFirestore.instance
      .collection('Users')
      .doc(userId)
      .collection('Reviews');
  
  return reviewsCollection.aggregate(average("rating")).get().then(
      (res) => res.getAverage("rating")
  );
});