import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class EditProfile extends ConsumerStatefulWidget {
  const EditProfile({super.key});

  @override
  ConsumerState<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  Future<void>? _profileFuture;

  Color _selectedColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    _profileFuture = _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      final doc = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        _nameController.text = data['username']?.toString() ?? '';
        _bioController.text = data['aboutme']?.toString() ?? '';

        final int? colorInt = data['color'] as int?;
        if (colorInt != null) {
          setState(() {
            _selectedColor = Color(0xFF000000 | colorInt);
          });
        }
      }
    } catch (_) {}
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
      final int rgb = _selectedColor.value & 0x00FFFFFF;

      await FirebaseFirestore.instance.collection('Users').doc(uid).update({
        'username': nameT.split(" ").join(".").toLowerCase(),
        'aboutme': _bioController.text.trim(),
        'color': rgb,
      });
      _showSuccessDialog();
    } catch (_) {
      _showErrorDialog("Something went wrong. Please try again later.");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text("OK"))],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => AlertDialog(
        title: const Text("Profile updated"),
        content: const Text("Your profile has been updated successfully"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/homescreen'),
            child: const Text("Back to home"),
          )
        ],
      ),
    );
  }

  Future<void> _pickColor() async {
    Color pickedColor = _selectedColor;

    await showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Pick a color'),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: _selectedColor,
            onColorChanged: (color) => pickedColor = color,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(c);
              setState(() {
                _selectedColor = pickedColor;
              });
            },
            child: const Text('Select'),
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
                    onTap: _pickColor,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: _selectedColor,
                      child: Icon(
                        Icons.color_lens_outlined,
                        size: 40,
                        color: ThemeData.estimateBrightnessForColor(_selectedColor) == Brightness.dark
                            ? Colors.white
                            : Colors.black,
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
                        child: Text('Save changes', style: TextStyle(fontSize: 16)),
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
