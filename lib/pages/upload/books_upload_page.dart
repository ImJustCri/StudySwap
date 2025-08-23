import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/subjects_providers.dart';
import '../../services/compression/posts_compression.dart';
import '../../widgets/thumbnail_picker.dart';
import 'contact_input.dart';
import 'package:studyswap/services/traslation_manager.dart';

class BooksUploadPage extends ConsumerStatefulWidget {
  const BooksUploadPage({super.key});

  @override
  ConsumerState<BooksUploadPage> createState() => _BooksUploadPageState();
}

class _BooksUploadPageState extends ConsumerState<BooksUploadPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedSubject;

  File? _selectedImage;

  String? _contactPlatform;
  String? _contactHandle;

  bool _isUploading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _costController.dispose();
    _subjectController.dispose();
    _isbnController.dispose();
    _yearController.dispose();
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

      setState(() {
        _isUploading = true;
      });

      final title = _titleController.text.trim();
      final subject = _selectedSubject ?? _subjectController.text.trim();
      final cost = int.parse(_costController.text.trim());
      final isbn = _isbnController.text.trim();
      final year = int.parse(_yearController.text.trim());
      final description = _descriptionController.text.trim();
      final contactPlatform = _contactPlatform!;
      final contactHandle = _contactHandle!;

      await _uploadNote(
        title: title,
        subject: subject,
        cost: cost,
        isbn: isbn,
        year: year,
        description: description,
        contactPlatform: contactPlatform,
        contactHandle: contactHandle,
      );

      _formKey.currentState?.reset();
      _titleController.clear();
      _costController.clear();
      _subjectController.clear();
      _isbnController.clear();
      _yearController.clear();
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
          Translation.of(context)!.translate("books.titlePage"),
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
        ),
        leading: const BackButton(),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
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
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration:  InputDecoration(
                        labelText: Translation.of(context)!.translate("labelTitle"),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.book),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return Translation.of(context)!.translate("titleEmpty");
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 4),
                       Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        Translation.of(context)!.translate("books.hintTitle"),
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Autocomplete<String>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return const Iterable<String>.empty();
                        }
                        return subjects.where((subject) =>
                            subject.toLowerCase().contains(textEditingValue.text.toLowerCase()));
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
                        Translation.of(context)!.translate("books.hintSubject"),
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
                        Translation.of(context)!.translate("books.hintDescription"),
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
                          return Translation.of(context)!.translate("books.labelCost");
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 4),
                       Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        Translation.of(context)!.translate("books.hintCost"),
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _isbnController,
                      decoration:  InputDecoration(
                        labelText: 'ISBN',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.confirmation_number),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return Translation.of(context)!.translate("books.labelISBNEmpty");
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 4),
                       Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        Translation.of(context)!.translate("books.hintISBN"),
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _yearController,
                      keyboardType: TextInputType.number,
                      decoration:  InputDecoration(
                        labelText: Translation.of(context)!.translate("books.labelYear"),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return Translation.of(context)!.translate("books.labelYearEmpty");
                        }
                        final year = int.tryParse(value.trim());
                        final currentYear = DateTime.now().year;
                        if (year == null || year < 1000 || year > currentYear) {
                          return Translation.of(context)!.translate("books.labellYearErrors")+"$currentYear";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 4),
                       Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        Translation.of(context)!.translate("books.hintYear"),
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
    required String description,
    required int cost,
    required String isbn,
    required int year,
    required String contactPlatform,
    required String contactHandle,
  }) async {
    try {
      final booksCollection = FirebaseFirestore.instance.collection('Books');

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

      final imageUrl = Supabase.instance.client.storage
          .from('thumbnails')
          .getPublicUrl("$userId/$noteUid");

      final newDocRef = booksCollection.doc(noteUid);

      await newDocRef.set({
        'id': noteUid,
        'title': title,
        'subject': subject,
        'description': description,
        'price': cost,
        'isbn': isbn,
        'year': year,
        'user_id': FirebaseAuth.instance.currentUser?.uid,
        'createdAt': FieldValue.serverTimestamp(),
        'image_url': imageUrl,
        'currency': "€",
        'contact_platform': contactPlatform,
        'contact_handle': contactHandle,
      });

      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text(Translation.of(context)!.translate("MessageSuccessful"))),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(Translation.of(context)!.translate("MessageUnsuccessful")+"$e")),
      );
    }
  }
}
