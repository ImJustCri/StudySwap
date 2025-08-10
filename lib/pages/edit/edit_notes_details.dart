import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/subjects_providers.dart';

class EditNotesPage extends ConsumerStatefulWidget {
  final String noteId;
  final String title;
  final String subject;
  final String userId;
  final int price;
  final String description;
  final String imageUrl;

  const EditNotesPage({
    super.key,
    required this.noteId,
    required this.title,
    required this.subject,
    required this.userId,
    required this.price,
    required this.description,
    required this.imageUrl,
  });

  @override
  ConsumerState<EditNotesPage> createState() => _EditNotesPageState();
}

class _EditNotesPageState extends ConsumerState<EditNotesPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _priceController;
  late final TextEditingController _subjectController;
  late final TextEditingController _descriptionController;

  String? _selectedSubject;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.title);
    _priceController = TextEditingController(text: widget.price.toString());
    _subjectController = TextEditingController(text: widget.subject);
    _descriptionController = TextEditingController(text: widget.description);

    _selectedSubject = widget.subject;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text.trim();
      final subject = _selectedSubject ?? _subjectController.text.trim();
      final price = int.parse(_priceController.text.trim());
      final description = _descriptionController.text.trim();

      await _updateNote(
        title: title,
        subject: subject,
        price: price,
        description: description,
      );

      // After update, reset form and go back
      _formKey.currentState!.reset();
      setState(() {
        _selectedSubject = null;
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
        title: const Text(
          "Edit Note",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
        ),
        leading: const BackButton(),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // CachedNetworkImage(imageUrl: widget.imageUrl),
                // const SizedBox(height: 16),

                // Title input
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

                // Subject autocomplete
                Autocomplete<String>(
                  optionsBuilder: (textEditingValue) {
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
                    controller.text = widget.subject;
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
                    'Select or type the subject related to your notes.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 16),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  maxLines: null,
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

                // Price
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a price';
                    }
                    final parsed = int.tryParse(value.trim());
                    if (parsed == null || parsed < 0) {
                      return 'Please enter a positive value';
                    }
                    if (parsed == 0) {
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
                    onPressed: _submitForm,
                    child: const Text('Submit', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateNote({
    required String title,
    required String subject,
    required int price,
    required String description,
  }) async {
    try {
      final notesDoc = FirebaseFirestore.instance.collection('Notes').doc(widget.noteId);
      final imageUrlToSave = widget.imageUrl;

      await notesDoc.update({
        'title': title,
        'subject': subject,
        'price': price,
        'user_id': FirebaseAuth.instance.currentUser?.uid,
        'description': description,
        'image_url': imageUrlToSave,
        'latest_update': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update note: $e')),
      );
    }
  }
}
