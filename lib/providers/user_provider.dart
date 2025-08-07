import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for the current user's auth session
final userProvider = StreamProvider<User?>(
      (ref) => FirebaseAuth.instance.authStateChanges(),
);