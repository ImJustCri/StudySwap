import 'dart:io';
import 'package:studyswap/pages/upload/note_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../providers/subjects_providers.dart';
import '../../services/compression/posts_compression.dart';
import '../../widgets/thumbnail_picker.dart';
import 'contact_input.dart';
import 'package:studyswap/providers/traslation_provider.dart';

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
  File? _selectedNote;


  String? _contactPlatform;
  String? _contactHandle;

  bool _isUploading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _costController.dispose();
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_isUploading) return;

    if (_formKey.currentState?.validate() ?? false) {
      if (_contactHandle == null || _contactHandle!.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(Translation.of(context)!.translate("contactHandle"))),
        );
        return;
      }

      if (_selectedNote == null) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(Translation.of(context)!.translate("notes.fileNotUpload"))),
        );
        return;
      }


      setState(() {
        _isUploading = true;
      });

      final title = _titleController.text.trim();
      final subject = _selectedSubject ?? _subjectController.text.trim();
      final cost = int.parse(_costController.text.trim());
      final description = _descriptionController.text.trim();
      final contactPlatform = _contactPlatform!;
      final contactHandle = _contactHandle!;

      await _uploadNote(
        title: title,
        subject: subject,
        cost: cost,
        description: description,
        contactPlatform: contactPlatform,
        contactHandle: contactHandle,
      );

      _formKey.currentState?.reset();
      _titleController.clear();
      _costController.clear();
      _subjectController.clear();
      _descriptionController.clear();

      setState(() {
        _selectedSubject = null;
        _selectedImage = null;
        _contactPlatform = null;
        _contactHandle = null;
        _isUploading = false;
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subjects = ref.watch(subjectsProvider);
    return Scaffold(
      appBar: AppBar(
        title:  Text(
          Translation.of(context)!.translate("notes.titlePage"),
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
                      decoration:  InputDecoration(
                        labelText: Translation.of(context)!.translate("labelTitle"),
                        prefixIcon: Icon(Icons.note_add_rounded),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return Translation.of(context)!.translate("labelTitleEmpty");
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 4),
                      Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        Translation.of(context)!.translate("notes.hintTitle"),
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
                          decoration:  InputDecoration(
                            labelText: Translation.of(context)!.translate("labelSubject"),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.category),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return Translation.of(context)!.translate("labelSubjectEmpty");
                            }
                            if (!subjects.contains(value.trim())) {
                              return Translation.of(context)!.translate("labelSubjectInvalid");
                            }
                            return null;
                          },
                          onEditingComplete: onEditingComplete,
                        );
                      },
                    ),
                    const SizedBox(height: 4),
                       Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        Translation.of(context)!.translate("notes.hintSubject"),
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),

                    const SizedBox(height: 16),
                    TextFormField(
                      maxLines: null,
                      controller: _descriptionController,
                      decoration:  InputDecoration(
                        labelText: Translation.of(context)!.translate("labelDescription"),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.book),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return Translation.of(context)!.translate("labelDescriptionEmpty");
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 4),
                       Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        Translation.of(context)!.translate("notes.hintDescription"),
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _costController,
                      keyboardType: TextInputType.number,
                      decoration:  InputDecoration(
                        labelText: Translation.of(context)!.translate("labelCost"),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return Translation.of(context)!.translate("labelCostEmpty");
                        }
                        final cost = int.tryParse(value.trim());
                        if (cost == null || cost < 0) {
                          return Translation.of(context)!.translate("labelCostInvalidValue");
                        } else if (cost == 0) {
                          return Translation.of(context)!.translate("notes.labelCostInvalidValue1");
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 4),
                       Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        Translation.of(context)!.translate("notes.hintCost"),
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 24),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        Translation.of(context)!.translate("titleContact"),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ContactInput(
                      initialPlatform: _contactPlatform,
                      initialHandle: _contactHandle,
                      onChanged: (platform, handle) {
                        _contactPlatform = platform;
                        _contactHandle = handle;
                      },
                    ),
                    const SizedBox(height: 4),
                       Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        Translation.of(context)!.translate("hintContact"),
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 16),
                    NotePicker(
                      initialFile: _selectedNote,
                      onFilePicked: (file) {
                        setState(() {
                          _selectedNote = file;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isUploading ? null : _submitForm,
                        child: _isUploading
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                            :  Text(Translation.of(context)!.translate("button"), style: TextStyle(fontSize: 16)),
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
    required String contactPlatform,
    required String contactHandle,
  }) async {
    try {
      final notesCollection = FirebaseFirestore.instance.collection('Notes');

      if (_selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(Translation.of(context)!.translate("imageNotUpload"))),
        );
        return;
      }

      final noteUid = const Uuid().v4();

      final compressedImageFile = await PostsCompressor.compressImage(_selectedImage!);

      final userId = FirebaseAuth.instance.currentUser?.uid;

      await Supabase.instance.client.storage
          .from('thumbnails')
          .upload("$userId/$noteUid", compressedImageFile);

      await Supabase.instance.client.storage
          .from('notes')
          .upload("$userId/$noteUid", _selectedNote!);

      final noteUrl = Supabase.instance.client.storage
          .from('notes')
          .getPublicUrl("$userId/$noteUid");

      final imageUrl = Supabase.instance.client.storage
          .from('thumbnails')
          .getPublicUrl("$userId/$noteUid");

      final newDocRef = notesCollection.doc(noteUid);

      await newDocRef.set({
        'id': noteUid,
        'title': title,
        'subject': subject,
        'price': cost,
        'user_id': FirebaseAuth.instance.currentUser?.uid,
        'description': description,
        'contact_platform': contactPlatform,
        'contact_handle': contactHandle,
        'createdAt': FieldValue.serverTimestamp(),
        'image_url': imageUrl,
        'note_url': noteUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text(Translation.of(context)!.translate("notes.MessageSuccessful"))),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(Translation.of(context)!.translate("notes.MessageUnsuccessful")+"$e")),
      );
    }
  }
}