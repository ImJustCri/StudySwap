import 'package:flutter_riverpod/flutter_riverpod.dart';

// List of subjects
final List<String> subjects = const [
  "Information Technology",
  "Mathematics",
  "Telecommunications",
  "History",
  "Physical Education",
  "Italian Literature",
  "Systems and Networking",
  "English Language",
  "TPSIT",
  "Business Economics",
  "Catholic Religion",
  "Law and Economics",
  "Physics",
  "Chemistry",
  "Biology",
  "Earth Sciences",
];

final subjectsProvider = Provider<List<String>>((ref) {
  return subjects;
});