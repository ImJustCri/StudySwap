import 'package:cloud_firestore/cloud_firestore.dart';

class CoinsManager {
  final FirebaseFirestore _firestore;

  CoinsManager({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Adds [amount] coins to the user document with ID [userId].
  /// Throws exceptions if the update fails.
  Future<void> addCoins(String userId, int amount) async {
    if (amount <= 0) {
      throw ArgumentError('Amount to add must be positive');
    }

    final docRef = _firestore.collection('Users').doc(userId);

    await docRef.update({
      'coins': FieldValue.increment(amount),
    });
  }

  /// Removes [amount] coins from the user document with ID [userId].
  /// Throws exceptions if the update fails.
  Future<void> removeCoins(String userId, int amount) async {
    if (amount <= 0) {
      throw ArgumentError('Amount to remove must be positive');
    }

    final docRef = _firestore.collection('Users').doc(userId);

    await docRef.update({
      'coins': FieldValue.increment(-amount),
    });
  }
}
