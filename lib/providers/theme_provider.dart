import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_provider.dart';

// Provider to check whether the user has dark mode enabled or not
final darkModeProvider = StreamProvider<bool?>((ref) {
  final userStream = ref.watch(userProvider);
  var currentUser = userStream.value;

  if (currentUser != null) {
    var docRef = FirebaseFirestore.instance.collection('Users').doc(currentUser.uid);

    return docRef.snapshots().map((doc) {
      var data = doc.data();
      if (data != null && data.containsKey('darkmode')) {
        return data['darkmode'] as bool?;
      }
      return null;
    });
  } else {
    return Stream.value(null);
  }
});

// Provider for updating dark mode preference in Firestore
final darkModeUpdateProvider = Provider((ref) {
  return (bool newDarkMode) async {
    final userStream = ref.read(userProvider);
    final currentUser = userStream.value;

    if (currentUser != null) {
      final docRef = FirebaseFirestore.instance.collection('Users').doc(currentUser.uid);
      await docRef.update({'darkmode': newDarkMode});
    }
  };
});