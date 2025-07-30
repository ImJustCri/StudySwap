import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final userProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final dataProvider = StreamProvider<Map<String, dynamic>?>((ref) {
  final userStream = ref.watch(userProvider);
  var currentUser = userStream.value;

  if (currentUser != null) {
    var docRef = FirebaseFirestore.instance.collection('Users').doc(currentUser.uid);
    return docRef.snapshots().map((doc) => doc.data());
  } else {
    return const Stream.empty();
  }
});

class EditProfile extends ConsumerStatefulWidget {
  const EditProfile({super.key});

  @override
  ConsumerState<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  Future<void>? _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final userDataAsync = ref.read(dataProvider);
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      final doc = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        _nameController.text = data['username']?.toString() ?? '';
        _bioController.text = data['aboutme']?.toString() ?? '';
      }
    } catch (e) {
      // Optionally handle error
    }
  }

  Future<void> _saveProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final nameT = _nameController.text.trim();
    if (nameT.isEmpty) {
      _showErrorDialog("A username is required to save changes.");
      return;
    }

    if (nameT.length > 20) {
      _showErrorDialog("Username cannot exceed 20 characters.");
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('Users').doc(uid).update({
        'username': nameT.split(" ").join(".").toLowerCase(),
        'aboutme': _bioController.text.trim(),
      });
      _showSuccessDialog();
    } catch (e) {
      _showErrorDialog("Something went wrong. Please try again later.");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Profile updated"),
        content: const Text("Your profile has been updated successfully"),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, '/homescreen'),
            child: const Text("Back to home"),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Edit profile")),
      body: FutureBuilder(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      // TODO: Implement profile picture change
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: theme.colorScheme.primary.withAlpha(25),
                      child: Icon(
                        Icons.camera_alt_outlined,
                        size: 40,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                      hintText: 'Enter your new username',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _bioController,
                    decoration: const InputDecoration(
                      labelText: 'Bio',
                      border: OutlineInputBorder(),
                      hintText: 'Tell us about yourself',
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 56,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        textStyle: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Save changes'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
