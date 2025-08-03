import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notesProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  var collectionRef = FirebaseFirestore.instance.collection('Notes');

  return collectionRef.snapshots().map(
        (querySnapshot) => querySnapshot.docs.map(
          (doc) => doc.data(),
    ).toList(),
  );
});

final userNotesProvider = StreamProvider.family<List<Map<String, dynamic>>, String>((ref, userId) {
  var collectionRef = FirebaseFirestore.instance.collection('Notes');

  // Query where user_id equals the provided userId
  var query = collectionRef.where('user_id', isEqualTo: userId);

  return query.snapshots().map(
        (querySnapshot) => querySnapshot.docs.map(
          (doc) => doc.data(),
    ).toList(),
  );
});
