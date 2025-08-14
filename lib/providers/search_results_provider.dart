import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Notes provider to query by title
final notesByTitlePrefixProvider = StreamProvider.family<List<Map<String, dynamic>>, String>((ref, prefix) {
  final collectionRef = FirebaseFirestore.instance.collection('Notes');

  final query = collectionRef
      .orderBy('title')
      .startAt([prefix])
      .endAt(['$prefix\uf8ff'])
      .limit(20);

  return query.snapshots().map(
        (querySnapshot) => querySnapshot.docs.map(
          (doc) => doc.data(),
    ).toList(),
  );
});


// Books provider to query by title
final booksByTitlePrefixProvider = StreamProvider.family<List<Map<String, dynamic>>, String>((ref, prefix) {
  final collectionRef = FirebaseFirestore.instance.collection('Books');

  final query = collectionRef
      .orderBy('title')
      .startAt([prefix])
      .endAt(['$prefix\uf8ff'])
      .limit(20);

  return query.snapshots().map(
        (querySnapshot) => querySnapshot.docs.map(
          (doc) => doc.data(),
    ).toList(),
  );
});


// Profiles provider to query by username
final profilesByUsernamePrefixProvider = StreamProvider.family<List<Map<String, dynamic>>, String>((ref, prefix) {
  final collectionRef = FirebaseFirestore.instance.collection('Users');

  final query = collectionRef
      .orderBy('username')
      .startAt([prefix])
      .endAt(['$prefix\uf8ff'])
      .limit(20);

  return query.snapshots().map(
        (querySnapshot) => querySnapshot.docs.map(
          (doc) => doc.data(),
    ).toList(),
  );
});

