import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Every book in the database
final booksProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  var collectionRef = FirebaseFirestore.instance.collection('Books');

  return collectionRef.snapshots().map(
        (querySnapshot) => querySnapshot.docs.map(
          (doc) => doc.data(),
    ).toList(),
  );
});

// Books from a certain user
final userBooksProvider = StreamProvider.family<List<Map<String, dynamic>>, String>((ref, userId) {
  var collectionRef = FirebaseFirestore.instance.collection('Books');

  // Query where user_id equals the provided userId
  var query = collectionRef.where('user_id', isEqualTo: userId);

  return query.snapshots().map(
        (querySnapshot) => querySnapshot.docs.map(
          (doc) => doc.data(),
    ).toList(),
  );
});

// Books filtered by subject, latest 20 uploads
final booksBySubjectProvider = StreamProvider.family<List<Map<String, dynamic>>, String>((ref, subject) {
  final collectionRef = FirebaseFirestore.instance.collection('Books');

  final query = collectionRef
      .where('subject', isEqualTo: subject)
      .orderBy('createdAt', descending: true)
      .limit(20);

  return query.snapshots().map(
        (querySnapshot) => querySnapshot.docs.map(
          (doc) => doc.data(),
    ).toList(),
  );
});

