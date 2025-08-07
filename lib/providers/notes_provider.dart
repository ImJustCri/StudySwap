import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studyswap/providers/data_provider.dart';
import 'package:studyswap/providers/subjects_providers.dart';


// Every note in the database
final notesProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  var collectionRef = FirebaseFirestore.instance.collection('Notes');

  return collectionRef.snapshots().map(
        (querySnapshot) => querySnapshot.docs.map(
          (doc) => doc.data(),
    ).toList(),
  );
});


// Notes from a certain user
final userNotesProvider = StreamProvider.family<List<Map<String, dynamic>>, String>((ref, userId) {
  var collectionRef = FirebaseFirestore.instance.collection('Notes');

  var query = collectionRef.where('user_id', isEqualTo: userId);

  return query.snapshots().map(
        (querySnapshot) => querySnapshot.docs.map(
          (doc) => doc.data(),
    ).toList(),
  );
});

// Latest notes uploaded (last 20)
final last20NotesProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  var collectionRef = FirebaseFirestore.instance.collection('Notes');

  var query = collectionRef.orderBy('createdAt', descending: true).limit(20);

  return query.snapshots().map(
        (querySnapshot) => querySnapshot.docs.map(
          (doc) => doc.data(),
    ).toList(),
  );
});

// Notes based on preferences
final suggestedNotesProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final favoriteSubjectsAsync = ref.watch(favoriteSubjectsProvider);

  var collectionRef = FirebaseFirestore.instance.collection('Notes');

  // If favoriteSubjectsProvider is loading or has error, fallback to an empty stream or all notes maybe
  if (favoriteSubjectsAsync is AsyncLoading || favoriteSubjectsAsync is AsyncError) {
    // Return empty list stream or all notes stream, depending on your logic
    return Stream.value(<Map<String, dynamic>>[]);
  }

  final favoriteSubjects = favoriteSubjectsAsync.value ?? [];

  if (favoriteSubjects.isEmpty) {
    // Firestore query with empty whereIn list causes errors,
    // so return empty stream here
    return Stream.value(<Map<String, dynamic>>[]);
  }

  final limitedSubjects = favoriteSubjects.length > 10
      ? favoriteSubjects.sublist(0, 10)
      : favoriteSubjects;

  final query = collectionRef
      .where('subject', whereIn: limitedSubjects)
      .orderBy('createdAt', descending: true)
      .limit(20);

  return query.snapshots().map(
        (querySnapshot) => querySnapshot.docs.map(
          (doc) => doc.data(),
    ).toList(),
  );
});

