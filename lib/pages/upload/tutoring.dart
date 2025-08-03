import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/subjects_providers.dart';

class TutoringUploadPage extends ConsumerStatefulWidget {
  const TutoringUploadPage({super.key});

  @override
  ConsumerState<TutoringUploadPage> createState() => _TutoringUploadPageState();
}

class _TutoringUploadPageState extends ConsumerState<TutoringUploadPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _subjectController = TextEditingController();

  String? _selectedSubject;
  final Set<int> _selectedClasses = {};

  @override
  void dispose() {
    _subjectController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final subject = _selectedSubject ?? _subjectController.text.trim();

      if (_selectedClasses.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one class')),
        );
        return;
      }

      // Convert selected classes to bool list of length 5
      final classesBoolList =
      List<bool>.generate(5, (index) => _selectedClasses.contains(index + 1));

      await _uploadTutoring(subject: subject, classes: classesBoolList);

      // Clear form & exit
      _formKey.currentState!.reset();
      setState(() {
        _selectedSubject = null;
        _selectedClasses.clear();
        _subjectController.clear();
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
          "Upload Tutoring",
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
                        return subjects.where((subject) =>
                            subject.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                      },
                      onSelected: (selection) {
                        setState(() {
                          _selectedSubject = selection;
                          _subjectController.text = selection;
                        });
                      },
                      fieldViewBuilder:
                          (context, controller, focusNode, onEditingComplete) {
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
                    const Text(
                      'Select or type the subject area for the tutoring (e.g., Mathematics, History).',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),

                    // Class selection chips
                    Text(
                      "Select Classes",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Select one or more classes you are offering tutoring for (e.g., Class 1 to Class 5).',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: List.generate(5, (index) {
                        final classNumber = index + 1;
                        final isSelected = _selectedClasses.contains(classNumber);

                        return FilterChip(
                          label: Text('Class $classNumber'),
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
                  ],
                ),
              ),
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
                    child: Text(
                      'Submit',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _uploadTutoring({
    required String subject,
    required List<bool> classes,
  }) async {
    try {
      final tutoringCollection = FirebaseFirestore.instance.collection('Tutoring');

      await tutoringCollection.add({
        'subject': subject,
        'classes': classes,
        'user_id': FirebaseAuth.instance.currentUser?.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tutoring uploaded successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload tutoring: $e')),
      );
    }
  }
}
