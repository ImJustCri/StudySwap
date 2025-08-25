import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/subjects_providers.dart';
import 'package:studyswap/services/traslation_manager.dart';

import 'contact_section.dart';
class TutoringUploadPage extends ConsumerStatefulWidget {
  const TutoringUploadPage({super.key});

  @override
  ConsumerState<TutoringUploadPage> createState() => _TutoringUploadPageState();
}

class _TutoringUploadPageState extends ConsumerState<TutoringUploadPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();

  String? _selectedMode;
  String? _selectedSubject;
  final Set<int> _selectedClasses = {};

  bool _isUploading = false;

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    _hoursController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_isUploading) return;

    if (_formKey.currentState!.validate()) {

      if (_selectedClasses.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(Translation.of(context)!.translate("tutoring.ClassEmpty"))),
        );
        return;
      }

      setState(() {
        _isUploading = true;
      });

      final subject = _selectedSubject ?? _subjectController.text.trim();
      final description = _descriptionController.text.trim();
      final mode = _selectedMode!;
      final hours = double.parse(_hoursController.text.trim());

      // Convert selected classes to bool list of length 5
      final classesBoolList =
      List<bool>.generate(5, (index) => _selectedClasses.contains(index + 1));

      await _uploadTutoring(
        subject: subject,
        classes: classesBoolList,
        description: description,
        mode: mode,
        hours: hours,
      );

      // Clear form & reset states
      _formKey.currentState!.reset();
      _subjectController.clear();
      _descriptionController.clear();
      _hoursController.clear();

      setState(() {
        _selectedSubject = null;
        _selectedMode = null;
        _selectedClasses.clear();
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
          Translation.of(context)!.translate("tutoring.titlePage"),
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
        ),
        leading: const BackButton(),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    // Subject Autocomplete
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
                       Text(
                      Translation.of(context)!.translate("tutoring.hintSubject"),
                      style: TextStyle(fontSize: 12, color: Colors.grey),
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
                    Text(
                      Translation.of(context)!.translate("tutoring.hintDescription"),
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),

                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _hoursController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: Translation.of(context)!.translate("tutoring.labelHours"),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.access_time),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return Translation.of(context)!.translate("tutoring.HoursEmpty");
                        }
                        final parsed = double.tryParse(value);
                        if (parsed == null || parsed <= 0) {
                          return Translation.of(context)!.translate("tutoring.HoursInvalid");
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 4),
                    Text(
                      Translation.of(context)!.translate("tutoring.hintHours"),
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),

                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration:  InputDecoration(
                        labelText: Translation.of(context)!.translate("tutoring.mode.title"),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.device_hub),
                      ),
                      initialValue: _selectedMode,
                      items: [
                        DropdownMenuItem(value: "digital", child: Text(Translation.of(context)!.translate("tutoring.mode.digital"),)),
                        DropdownMenuItem(value: "irl", child: Text(Translation.of(context)!.translate("tutoring.mode.irl"),)),
                        DropdownMenuItem(value: "both", child: Text(Translation.of(context)!.translate("tutoring.mode.both"),)),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedMode = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return Translation.of(context)!.translate("tutoring.mode.modeEmpty");
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 4),
                     Text(
                      Translation.of(context)!.translate("tutoring.mode.hint"),
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),

                    const SizedBox(height: 24),

                    Text(
                      Translation.of(context)!.translate("tutoring.ClassesTitle"),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      Translation.of(context)!.translate("tutoring.hintClasses"),
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: List.generate(5, (index) {
                        final classNumber = index + 1;
                        final isSelected = _selectedClasses.contains(classNumber);

                        return FilterChip(
                          label: Text("${Translation.of(context)!.translate("tutoring.class")}$classNumber"),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedClasses.add(classNumber);
                              } else {
                                _selectedClasses.remove(classNumber);
                              }
                            });
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 24),

                    // Contact Section
                    const ContactSection(),
                  ],
                ),
              ),

              // Submit Button fixed below the scrollable content
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
                      : Text(Translation.of(context)!.translate("button"), style: TextStyle(fontSize: 16)),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _uploadTutoring({
    required String subject,
    required String description,
    required List<bool> classes,
    required String mode,
    required double hours,
  }) async {
    try {
      final tutoringCollection = FirebaseFirestore.instance.collection('Tutoring');

      // Create a new document reference with an autogenerated ID
      final newDocRef = tutoringCollection.doc();

      await newDocRef.set({
        'id': newDocRef.id,
        'subject': subject,
        'classes': classes,
        'user_id': FirebaseAuth.instance.currentUser?.uid,
        'description': description,
        'mode': mode,
        'hours': hours,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(Translation.of(context)!.translate("tutoring.MessageSuccessful"))),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${Translation.of(context)!.translate("tutoring.MessageSuccessful")} $e")),
      );
    }
  }
}
