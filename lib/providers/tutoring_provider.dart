import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for the tutoring sessions offered by a specific user
final userTutoringProvider = StreamProvider.family<List<Map<String, dynamic>>, String>((ref, userId) {
  var collectionRef = FirebaseFirestore.instance.collection('Tutoring');

  var query = collectionRef.where('user_id', isEqualTo: userId);

  return query.snapshots().map(
        (querySnapshot) => querySnapshot.docs.map(
          (doc) => doc.data(),
    ).toList(),
  );
});