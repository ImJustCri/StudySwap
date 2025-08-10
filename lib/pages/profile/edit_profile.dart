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

    final bytes = await pickedXFile.readAsBytes();
    img.Image? originalImage = img.decodeImage(bytes);
    if (originalImage == null) return;

    img.Image resizedImage = img.copyResize(originalImage, width: 128, height: 128);
    final resizedBytes = img.encodePng(resizedImage);

    final tempDir = Directory.systemTemp;

    // This is to avoid reusing the same temp file so flutter won't the old image due to caching
    final uniquePath = '${tempDir.path}/resized_profile_${DateTime.now().millisecondsSinceEpoch}.png';

    final resizedFile = await File(uniquePath).writeAsBytes(resizedBytes);

    setState(() {
      _selectedImageFile = resizedFile;
    });
  }

  Future<String> _uploadImage(File file, String uid) async {
    final storage = Supabase.instance.client.storage.from('pfp');
    final filePath = '$uid/pfp';

    await storage.upload(
      filePath,
      file,
      fileOptions: const FileOptions(upsert: true),
    );

    final url = storage.getPublicUrl(filePath);

    // Append timestamp query parameter to bust cache and show updated image immediately
    return '$url?updated=${DateTime.now().millisecondsSinceEpoch}';
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
        // Upload new image to Supabase and get cache-busted URL
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
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/homescreen'),
                  child: const Text("Back to Home"),
                ),
              ),
            ],
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

  Widget _buildProfileImage(ThemeData theme) {
    final existingImage = (_currentImageUrl != null && _currentImageUrl!.isNotEmpty)
        ? CachedNetworkImageProvider(_currentImageUrl!)
        : null;

    final newImage = _selectedImageFile != null ? FileImage(_selectedImageFile!) : null;

    Widget avatarContent;

    if (newImage == null) {
      avatarContent = CircleAvatar(
        radius: 48,
        backgroundColor: Colors.transparent,
        backgroundImage: existingImage,
        child: existingImage == null
            ? const Icon(Icons.camera_alt_outlined, size: 40, color: Colors.grey)
            : null,
      );
    } else {
      avatarContent = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: Colors.transparent,
            backgroundImage: existingImage,
            child: existingImage == null
                ? const Icon(Icons.person_outline, size: 40, color: Colors.grey)
                : null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Icon(Icons.arrow_forward_rounded, size: 36, color: theme.colorScheme.primary),
          ),
          CircleAvatar(
            radius: 48,
            backgroundColor: Colors.transparent,
            backgroundImage: newImage,
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: _pickImage,  // Call your image picker on tap
      child: avatarContent,
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
                        _buildProfileImage(theme),
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