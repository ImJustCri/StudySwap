import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/subjects_providers.dart';
import 'package:studyswap/services/traslation_manager.dart';
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
        title: Text(
          Translation.of(context)!.translate("edit.notes.title"),
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
                  decoration: InputDecoration(
                    labelText: Translation.of(context)!.translate("labelTitle"),
                    prefixIcon: Icon(Icons.note_add_rounded),
                    border: OutlineInputBorder(),
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
                    Translation.of(context)!.translate("notes.hintTitle"),
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 16),

                // Subject autocomplete
                Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<String>.empty();
                    }
                    // Filter subjects by matching translated text
                    return subjects.where((subject) {
                      final translated = Translation.of(context)!.translate("subjectsList.$subject");
                      return translated.toLowerCase().contains(textEditingValue.text.toLowerCase());
                    });
                  },
                  onSelected: (selection) {
                    setState(() {
                      _selectedSubject = selection;
                      _subjectController.text = Translation.of(context)!.translate("subjectsList.$selection");
                    });
                  },
                  optionsViewBuilder: (context, onSelected, options) {
                    return Material(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: options.length,
                        itemBuilder: (BuildContext context, int index) {
                          final subjectKey = options.elementAt(index);
                          final translated = Translation.of(context)!.translate("subjectsList.$subjectKey");
                          return ListTile(
                            title: Text(translated),
                            onTap: () {
                              onSelected(subjectKey);
                            },
                          );
                        },
                      ),
                    );
                  },
                  fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                    _subjectController.value = controller.value;
                    controller.text = Translation.of(context)!.translate("subjectsList.${widget.subject}");

                    return TextFormField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        labelText: Translation.of(context)!.translate("labelSubject"),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.category),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return Translation.of(context)!.translate("labelSubjectEmpty");
                        }
                        if (!subjects.contains(_selectedSubject)) {
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
                    Translation.of(context)!.translate("hintSubject"),
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 16),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  maxLines: null,
                  decoration: InputDecoration(
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

                // Price
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: Translation.of(context)!.translate("labelCost"),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return Translation.of(context)!.translate("labelCostEmpty");
                    }
                    final parsed = int.tryParse(value.trim());
                    if (parsed == null || parsed < 0) {
                      return Translation.of(context)!.translate("labelCostInvalidValue");
                    }
                    if (parsed == 0) {
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
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child:  Text(Translation.of(context)!.translate("button"), style: TextStyle(fontSize: 16)),
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
         SnackBar(content: Text(Translation.of(context)!.translate("MessageSuccessful"))),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${Translation.of(context)!.translate("MessageUnsuccessful")}$e")),
      );
    }
  }
}
