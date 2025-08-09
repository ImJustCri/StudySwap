import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image/image.dart' as img;


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

    // Read picked image bytes
    final bytes = await pickedXFile.readAsBytes();

    // Decode image
    img.Image? originalImage = img.decodeImage(bytes);
    if (originalImage == null) return;

    // Resize image to 64x64
    img.Image resizedImage = img.copyResize(originalImage, width: 64, height: 64);

    // Convert resized image back to bytes in PNG format
    final resizedBytes = img.encodePng(resizedImage);

    // Save resized image as temp file
    final tempDir = Directory.systemTemp;
    final resizedFile = await File('${tempDir.path}/resized_profile.png').writeAsBytes(resizedBytes);

    setState(() {
      _selectedImageFile = resizedFile;
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
    ImageProvider<Object>? displayImage;

    if (_selectedImageFile != null) {
      displayImage = FileImage(_selectedImageFile!);
    } else if (_currentImageUrl != null && _currentImageUrl!.isNotEmpty) {
      displayImage = CachedNetworkImageProvider(_currentImageUrl!);
    }

    return GestureDetector(
      onTap: _pickImage,
      child: CircleAvatar(
        radius: 48,
        backgroundColor: Colors.transparent,
        backgroundImage: displayImage,
        child: displayImage == null
            ? const Icon(Icons.camera_alt_outlined, size: 40, color: Colors.grey)
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
            child: Column(
              children: [
                Expanded(
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
                      ],
                    ),
                  ),
                ),

                // Button fixed at the bottom
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    child: const Text(
                      'Save Changes',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}