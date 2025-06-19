import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<String?> registerWithEmail(String email, String password) async {
    try {
      // Call to create the account on Firebase
      UserCredential utente = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Send verification email
      await utente.user?.sendEmailVerification();
      return null;
    } on FirebaseAuthException catch (ex) {
      return ex.message;
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      // Call to check if the account exists
      UserCredential utente = await auth.signInWithEmailAndPassword(email: email, password: password);
      await utente.user?.reload();
      final userAggiornato = auth.currentUser;
      if (userAggiornato != null && !userAggiornato.emailVerified) {
        await auth.signOut();
        return "Verify your email before logging in";
      }
      return null;
    } on FirebaseAuthException catch (ex) {
      return ex.message;
    }
  }

  Future<String?> resetPassword(String email) async {
    try {
      // Call to recover the password
      await auth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (ex) {
      return ex.message;
    }
  }
}
