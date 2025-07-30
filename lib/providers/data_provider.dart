import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studyswap/providers/user_provider.dart';

final dataProvider = StreamProvider<Map?>((ref) {
    final userStream = ref.watch(userProvider);
    var currentUser = userStream.value;

    if (currentUser != null) {
      var docRef = FirebaseFirestore.instance.collection('Users').doc(currentUser.uid);

      return docRef.snapshots().map((doc) => doc.data());
    } else {
      return Stream.empty();
    }
  },
);