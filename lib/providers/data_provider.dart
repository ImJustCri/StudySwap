import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dataProvider = StreamProvider.family<Map<String, dynamic>?, String>((ref, userId) {
  final docRef = FirebaseFirestore.instance.collection('Users').doc(userId);
  return docRef.snapshots().map((doc) => doc.data());
});
