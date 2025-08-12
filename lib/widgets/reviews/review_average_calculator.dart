import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewsAverageCalculator {
  final String userId;

  ReviewsAverageCalculator({required this.userId});

  Future<double> calculateAverage() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Reviews')
          .get();

      List<double> reviews = snapshot.docs
          .map((doc) => (doc.data()['rating'] as num).toDouble())
          .toList();

      if (reviews.isEmpty) return 0;

      double sum = reviews.reduce((a, b) => a + b);
      return sum / reviews.length;
    } catch (e) {
      rethrow;
    }
  }
}
