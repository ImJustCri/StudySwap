import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final contactProvider = StreamProvider.family<Map<String, dynamic>?, String>((ref, userId) {
  final docRef = FirebaseFirestore.instance.collection('Users').doc(userId);

  return docRef.snapshots().map((snapshot) {
    final data = snapshot.data();
    if (data == null) return null;
    return {
      'handle': data['contactHandle'],
      'platform': data['contactPlatform'],
    };
  });
});
