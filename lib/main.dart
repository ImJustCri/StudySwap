import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://mrskvszubvnunoowjeth.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1yc2t2c3p1YnZudW5vb3dqZXRoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ1ODIxNDAsImV4cCI6MjA3MDE1ODE0MH0.PlZqNa2EkakGs3pXYUNpmVOSy3yoa6rcZifHaZP46fY',
  );

  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}