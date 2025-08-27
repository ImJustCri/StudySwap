import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:studyswap/services/traslation_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

class Auth {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  Future<String?> registerWithEmail(String email, String password) async {
    try {
      // Call to create the account on Firebase
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Send verification email
      await userCredential.user?.sendEmailVerification();
      return null;
    } on FirebaseAuthException catch (ex) {
      return ex.message;
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      // Call to check if the account exists
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      await userCredential.user?.reload();
      final currentUser = auth.currentUser;
      if (currentUser != null && !currentUser.emailVerified) {
        await auth.signOut();
        return "Verify your email before logging in";
      }

      final uid = userCredential.user!.uid;
      final userDocRef = db.collection("Users").doc(uid);
      final userDoc = await userDocRef.get();
      // String? token= await FirebaseMessaging.instance.getToken();

      // Update collection "Users" to add new entry only when the email is verified
      // And only when the user hasn't been created yet

      if (!userDoc.exists) {
        await userDocRef
            .set({
          'username': email.split('@')[0],
          'school': email.split('@')[1],
          'aboutme' : "Hey there!",
          'stars': 0.0,
          'coins': 20,
          'image': "https://mrskvszubvnunoowjeth.supabase.co/storage/v1/object/public/pfp/default.png",
          'reviews-reference': 0,
          'email': userCredential.user!.email,
          'darkmode': false,
          'favorite_subjects': [],
          'user_id': uid,
        });
      }
      //load of database
      await LocaleManager.loadLanguage(uid);
      return null;
    } on FirebaseAuthException catch (ex) {
      return ex.message;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      // Call to recover the password
      await auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (ex) {
      debugPrint('Exception in deleteAccount: $ex');
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null && user.email != null) {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: oldPassword,
        );

        // Reauthenticate user (Check if oldPassword == actual user password)
        await user.reauthenticateWithCredential(credential);

        // After successful reauthentication, update password
        await user.updatePassword(newPassword);
      }
    } on FirebaseAuthException catch (ex) {
      debugPrint('Exception in changePassword: $ex');
      rethrow;
    }
  }

  /// Account deletion

  Future<void> deleteAccount() async{
    try{
      User? userCredential=FirebaseAuth.instance.currentUser;
      final userId = userCredential!.uid;

      // Call to delete the content in Users
      await FirebaseFirestore.instance.collection('Users').doc(userCredential.uid).delete();

      // Call to delete the user's uploads
      final firestore = FirebaseFirestore.instance;
      await deleteUploads(userCredential, firestore.collection("Notes"));
      await deleteUploads(userCredential, firestore.collection("Books"));
      await deleteUploads(userCredential, firestore.collection("Tutoring"));

      await Supabase.instance.client.storage.from('pfp').remove([userId]);

      // Call to delete the account
      await userCredential.delete();
        }on FirebaseAuthException catch (ex) {
      debugPrint('Exception in deleteAccount: $ex');
    }
  }

  Future<void> deleteUploads(User? currentUser, collectionRef) async {
    try {
      if (currentUser != null) {
        // Query all uploads where 'user_id' equals current user's uid
        final querySnapshot = await collectionRef.where('user_id', isEqualTo: currentUser.uid).get();

        for (final doc in querySnapshot.docs) {
          // Delete file from Supabase storage
          await Supabase.instance.client.storage.from('thumbnails').remove(["${currentUser.uid}/${doc["id"]}"]);

          // Delete Firestore document individually
          await doc.reference.delete();
        }
      }
    } on FirebaseAuthException catch (ex) {
      debugPrint('Exception in deleteAccount: $ex');
    }
  }

}

