import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostsManager {
  final FirebaseFirestore _firestore;
  final SupabaseStorageClient _supabase;

  PostsManager():
        _firestore = FirebaseFirestore.instance,
        _supabase = Supabase.instance.client.storage;

  Future<void> deleteNote(String postId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    await _firestore.collection('Notes').doc(postId).delete();

    await _supabase
        .from('thumbnails')
        .remove(['$userId/$postId']);
  }

  Future<void> deleteBook(String postId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    await _firestore.collection('Books').doc(postId).delete();
    await _supabase
        .from('thumbnails')
        .remove(['$userId/$postId']);
  }

  Future<void> deleteTutoring(String postId) async {
    await _firestore.collection('Tutoring').doc(postId).delete();
  }
}
