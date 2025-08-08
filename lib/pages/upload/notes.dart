import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../compression/posts_compression.dart';
import '../../providers/subjects_providers.dart';
import '../../widgets/thumbnail_picker.dart';

class NotesUploadPage extends ConsumerStatefulWidget {
  const NotesUploadPage({super.key});

  @override
  ConsumerState<NotesUploadPage> createState() => _NotesUploadPageState();
}

class _NotesUploadPageState extends ConsumerState<NotesUploadPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedSubject;

  File? _selectedImage;

  @override
  void dispose() {
    _titleController.dispose();
    _costController.dispose();
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text.trim();
      final subject = _selectedSubject ?? _subjectController.text.trim();
      final cost = int.parse(_costController.text.trim());
      final description = _descriptionController.text.trim();

      await _uploadNote(
        title: title,
        subject: subject,
        cost: cost,
        description: description,
      );

      // After upload, clear the form and reset
      _formKey.currentState!.reset();
      setState(() {
        _selectedSubject = null;
        _selectedImage = null;
      });
      _titleController.clear();
      _costController.clear();
      _subjectController.clear();
      _descriptionController.clear();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subjects = ref.watch(subjectsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Upload Notes",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
        ),
        leading: const BackButton(),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ThumbnailPicker(
              initialImage: _selectedImage,
              onImagePicked: (file) {
                setState(() {
                  _selectedImage = file;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        prefixIcon: Icon(Icons.note_add_rounded),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 4),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Enter the topic of your notes',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Autocomplete<String>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return const Iterable<String>.empty();
                        }
                        return subjects.where((subject) => subject.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                      },
                      onSelected: (selection) {
                        setState(() {
                          _selectedSubject = selection;
                          _subjectController.text = selection;
                        });
                      },
                      fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                        _subjectController.value = controller.value;

                        return TextFormField(
                          controller: controller,
                          focusNode: focusNode,
                          decoration: const InputDecoration(
                            labelText: 'Subject',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.category),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a subject';
                            }
                            if (!subjects.contains(value.trim())) {
                              return 'Please select a valid subject from the list';
                            }
                            return null;
                          },
                          onEditingComplete: onEditingComplete,
                        );
                      },
                    ),
                    const SizedBox(height: 4),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Select or type the subject related to your notes (e.g., Mathematics, History).',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),

                    const SizedBox(height: 16),
                    TextFormField(
                      maxLines: null,
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.book),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 4),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Add a brief description of the notes',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _costController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Cost',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a cost';
                        }
                        final cost = int.tryParse(value.trim());
                        if (cost == null || cost < 0) {
                          return 'Please enter a positive value';
                        } else if (cost == 0) {
                          return 'Your note cannot be free!';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 4),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Enter the price you want to charge for this note (must be greater than zero).',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 16),

                    SizedBox(
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
                        onPressed: _submitForm,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 14.0),
                          child: Text('Submit', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadNote({
    required String title,
    required String subject,
    required int cost,
    required String description,
  }) async {
    try {
      final notesCollection = FirebaseFirestore.instance.collection('Notes');

      if (_selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an image before uploading')),
        );
        return;
      }
      final imageUid = Uuid().v4();

      final compressedImageFile = await PostsCompressor.compressImage(_selectedImage!);

      await Supabase.instance.client.storage
          .from('thumbnails')
          .upload(imageUid, compressedImageFile);

      final imageUrl = Supabase.instance.client.storage
          .from('thumbnails')
          .getPublicUrl(imageUid);

      await notesCollection.add({
        'title': title,
        'subject': subject,
        'price': cost,
        'user_id': FirebaseAuth.instance.currentUser?.uid,
        'description': description,
        'createdAt': FieldValue.serverTimestamp(),
        'image_url': imageUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note uploaded successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload note: $e')),
      );
    }
  }
}
