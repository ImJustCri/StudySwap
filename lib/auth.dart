import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<String?> registerWithEmail(String email, String password) async {
    try {
      // Chiamatq per creare l'account su fireBase
      UserCredential utente = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Invia email di verifica
      await utente.user?.sendEmailVerification();
      return null;
    } on FirebaseAuthException catch (ex) {
      return ex.message;
    }
  }
  Future<String?> login(String email, String password) async{
    try{
      //chiamata per vedere se esiste l'account 
      UserCredential utente = await auth.signInWithEmailAndPassword(email: email, password: password);
      await utente.user?.reload();
      final userAggiornato = auth.currentUser;
      if(userAggiornato!=null && !userAggiornato.emailVerified){
        await auth.signOut();
        return "Verify your email before logging in";
      }
      return null;
    } on FirebaseAuthException catch(ex){
      return ex.message;
    }
  }
  Future<String?> resetPassword(String email) async{
    try{
      //chiamata per recuperare la password
      await auth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch(ex){
      return ex.message;
    }
  }
}

