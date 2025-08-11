import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        });
      }

      return null;
    } on FirebaseAuthException catch (ex) {
      return ex.message;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      // Call to recover the password
      await auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (ex) {}
  }


  Future<void> deleteAccount() async{
    try{
      User? userCredential=FirebaseAuth.instance.currentUser;
      if(userCredential!=null){
        // Call to delete the content in Users
        await FirebaseFirestore.instance.collection('Users').doc(userCredential.uid).delete();
        // Call to delete the account
        await userCredential.delete();
      }
    }on FirebaseAuthException catch (ex) {}
  }

  Future<void> changePassword(String password) async{
    try{
      User? userCredential= FirebaseAuth.instance.currentUser;
      if(userCredential!=null){
        // Call to modify the password
        await userCredential.updatePassword(password);
      }
    } on FirebaseAuthException catch(ex){}
  }

  // method is incomplete
  Future<void> changeEmail(String email) async{
    try{
      User? userCredential= FirebaseAuth.instance.currentUser;
      if(userCredential!=null){
        // Call to modify the email
        await userCredential.updateEmail(email); 

      }
    }on FirebaseAuthException catch(ex){}
  }
}

