import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_provider.dart';

// List of subjects
final List<String> subjects = const [
  "Information Technology",
  "Mathematics",
  "Telecommunications",
  "History",
  "Physical Education",
  "Italian Literature",
  "Systems and Networking",
  "English Language",
  "TPSIT",
  "Business Economics",
  "Catholic Religion",
  "Law and Economics",
  "Physics",
  "Chemistry",
  "Biology",
  "Earth Sciences",
  "Geography",
  "Astronomy",
  "Philosophy",
  "Sociology",
  "Political Science",
  "French Language",
  "Spanish Language",
  "German Language",
  "Chinese Language",
  "Art History",
  "Music",
  "Drama",
  "Technology",
  "Environmental Science",
  "Ethics",
  "Citizenship and Constitution",
  "Psychology",
  "Graphic Design",
  "Latin",
  "Ancient Greek",
  "Social Studies",
];


final subjectsProvider = Provider<List<String>>((ref) {
  return subjects;
});

//
// Favorite subjects provider
//

final favoriteSubjectsProvider = StreamProvider<List<String?>>((ref) {
  final userStream = ref.watch(userProvider);
  var currentUser = userStream.value;

  if (currentUser != null) {
    var docRef = FirebaseFirestore.instance.collection('Users').doc(currentUser.uid);

    return docRef.snapshots().map((doc) {
      var data = doc.data();
      if (data != null && data.containsKey('favorite_subjects')) {
        return (data['favorite_subjects'] as List<dynamic>).map((e) => e as String?).toList();

      }
      return <String?>[];
    });
  } else {
    return Stream.value(<String?>[]);
  }
});

//
// Updates user's favorite subjects
//

final updateFavoriteSubjectsProvider = Provider<FavoriteSubjectsRepository>((ref) {
  final userStream = ref.watch(userProvider);
  final currentUser = userStream.value;

  return FavoriteSubjectsRepository(currentUser?.uid);
});

class FavoriteSubjectsRepository {
  final String? uid;

  FavoriteSubjectsRepository(this.uid);

  Future<void> updateFavorites(List<String> favorites) async {
    if (uid == null) return;

    final docRef = FirebaseFirestore.instance.collection('Users').doc(uid);

    await docRef.update({
      'favorite_subjects': favorites,
    });
  }
}
