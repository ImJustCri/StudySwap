import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfile extends ConsumerStatefulWidget {
  const EditProfile({super.key});

  @override
  ConsumerState<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  Future<void>? _profileFuture;

  File? _selectedImageFile;
  String? _currentImageUrl;

  final _defaultImageUrl =
      "https://mrskvszubvnunoowjeth.supabase.co/storage/v1/object/public/pfp/default.png";

  @override
  void initState() {
    super.initState();
    _profileFuture = _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      final doc =
      await FirebaseFirestore.instance.collection('Users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        _nameController.text = data['username']?.toString() ?? '';
        _bioController.text = data['aboutme']?.toString() ?? '';
        _currentImageUrl = data['image']?.toString();
      }
    } catch (e) {
      debugPrint("Error loading profile: $e");
    }
    setState(() {});
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedXFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedXFile == null) return;

    setState(() {
      _selectedImageFile = File(pickedXFile.path);
    });
  }

  Future<String> _uploadImage(File file, String uid) async {
    final storage = Supabase.instance.client.storage.from('pfp');

    try {
      await storage.remove([uid]);
    } catch (_) {}

    await storage.upload(uid, file);
    return storage.getPublicUrl(uid);
  }

  Future<void> _saveProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final name = _nameController.text.trim();
    final bio = _bioController.text.trim();

    if (name.isEmpty) {
      _showErrorDialog("A username is required to save changes.");
      return;
    }

    if (name.length > 20) {
      _showErrorDialog("Username cannot exceed 20 characters.");
      return;
    }

    String imageUrlToSave = _currentImageUrl ?? _defaultImageUrl;

    try {
      if (_selectedImageFile != null) {
        // Upload new image to Supabase
        imageUrlToSave = await _uploadImage(_selectedImageFile!, uid);
        setState(() {
          _currentImageUrl = imageUrlToSave;
        });
      }

      // Save profile info to Firestore
      await FirebaseFirestore.instance.collection('Users').doc(uid).update({
        'username': name.replaceAll(" ", ".").toLowerCase(),
        'aboutme': bio,
        'image': imageUrlToSave,
      });

      _showSuccessDialog();
    } catch (e) {
      debugPrint("Error saving profile: $e");
      _showErrorDialog("Something went wrong. Please try again later.");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => AlertDialog(
        title: const Text("Profile Updated"),
        content: const Text("Your profile has been updated successfully."),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, '/homescreen'),
            child: const Text("Back to Home"),
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

  Widget _buildProfileImage() {
    final displayImage = _selectedImageFile != null
        ? FileImage(_selectedImageFile!)
        : (_currentImageUrl != null && _currentImageUrl!.isNotEmpty
        ? NetworkImage(_currentImageUrl!)
        : null);

    return GestureDetector(
      onTap: _pickImage,
      child: CircleAvatar(
        radius: 50,
        backgroundColor: Colors.transparent,
        backgroundImage: displayImage as ImageProvider<Object>?,
        child: displayImage == null
            ? const Icon(Icons.camera_alt_outlined,
            size: 40, color: Colors.grey)
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
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
                  _buildProfileImage(),
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
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
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
                      onPressed: _saveProfile,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14.0),
                        child:
                        Text('Save Changes', style: TextStyle(fontSize: 16)),
                      ),
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