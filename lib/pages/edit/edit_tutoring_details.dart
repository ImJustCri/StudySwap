import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studyswap/services/traslation_manager.dart';

class EditTutoringDetails extends ConsumerStatefulWidget {
  final String tutoringId;
  final String subject;
  final String description;
  final List<bool> classes;
  final String userId;
  final String mode;
  final num hours;

  const EditTutoringDetails({
    super.key,
    required this.tutoringId,
    required this.subject,
    required this.description,
    required this.classes,
    required this.userId,
    required this.mode,
    required this.hours,
  });

  @override
  ConsumerState<EditTutoringDetails> createState() => _TutoringUploadPageState();
}

class _TutoringUploadPageState extends ConsumerState<EditTutoringDetails> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();

  String? _selectedSubject;
  String? _selectedMode;
  final Set<int> _selectedClasses = {};

  @override
  void initState() {
    super.initState();

    _subjectController.text = widget.subject;
    _selectedSubject = widget.subject.isNotEmpty ? widget.subject : null;
    _descriptionController.text = widget.description;

    _selectedMode = widget.mode;
    _hoursController.text = widget.hours.toString();

    for (int i = 0; i < widget.classes.length; i++) {
      if (widget.classes[i]) {
        _selectedClasses.add(i + 1);
      }
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    _hoursController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final subject = _selectedSubject ?? _subjectController.text.trim();
      final description = _descriptionController.text.trim();

      if (_selectedClasses.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(Translation.of(context)!.translate("tutoring.ClassEmpty"))),
        );
        return;
      }

      final mode = _selectedMode!;
      final hours = double.parse(_hoursController.text.trim());

      final classesBoolList =
      List<bool>.generate(5, (index) => _selectedClasses.contains(index + 1));

      await _updateTutoring(
        subject: subject,
        classes: classesBoolList,
        description: description,
        mode: mode,
        hours: hours,
      );

      _formKey.currentState!.reset();
      setState(() {
        _selectedSubject = null;
        _selectedClasses.clear();
        _selectedMode = null;
        _hoursController.clear();
        _subjectController.clear();
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title:  Text(
          Translation.of(context)!.translate("edit.tutorin.title"),
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
                    // Subjects
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.category, color: Colors.grey),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              widget.subject,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      Translation.of(context)!.translate("edit.tutorin.hintSubject"),
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),

                    const SizedBox(height: 16),
                    // Description field
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
                      Translation.of(context)!.translate("edit.tutorin.hintDescription"),
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),

                    // Mode dropdown
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration:  InputDecoration(
                        labelText: Translation.of(context)!.translate("tutoring.mode.title"),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.device_hub),
                      ),
                      value: _selectedMode,
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

                    // Hours per session
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

                    const SizedBox(height: 24),

                    // Class selection chips
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
                          label: Text("${Translation.of(context)!.translate("tutoring.mode.class")}$classNumber"),
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
                  onPressed: _submitForm,
                  child:  Text(Translation.of(context)!.translate("button"), style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateTutoring({
    required String subject,
    required String description,
    required List<bool> classes,
    required String mode,
    required double hours,
  }) async {
    try {
      final tutoringDoc = FirebaseFirestore.instance
          .collection('Tutoring')
          .doc(widget.tutoringId);

      await tutoringDoc.update({
        'classes': classes,
        'user_id': FirebaseAuth.instance.currentUser?.uid,
        'description': description,
        'mode': mode,
        'hours_per_session': hours,
        'latest_update': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text(Translation.of(context)!.translate("tutoring.MessageSuccessful"))),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${Translation.of(context)!.translate("tutoring.MessageUnsuccessful")}$e")),
      );
    }
  }
}
