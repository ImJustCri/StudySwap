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

  /// Transfers [amount] coins from [fromUserId] to [toUserId].
  /// Throws exceptions if the update fails or if the [fromUserId] has insufficient coins.
  Future<void> transferCoins(String fromUserId, String toUserId, int amount) async {
    if (amount <= 0) {
      throw ArgumentError('Amount to transfer must be positive');
    }

    final fromUserRef = _firestore.collection('Users').doc(fromUserId);
    final toUserRef = _firestore.collection('Users').doc(toUserId);

    await _firestore.runTransaction((transaction) async {
      final fromSnapshot = await transaction.get(fromUserRef);

      final fromCoins = fromSnapshot.get('coins') ?? 0;

      if (fromCoins < amount) {
        throw Exception('Insufficient coins $fromCoins to transfer');
      }

      transaction.update(fromUserRef, {
        'coins': FieldValue.increment(-amount),
      });

      transaction.update(toUserRef, {
        'coins': FieldValue.increment(amount),
      });
    });
  }
}