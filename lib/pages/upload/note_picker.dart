import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:studyswap/providers/traslation_provider.dart';
class NotePicker extends StatefulWidget {
  final File? initialFile;
  final ValueChanged<File?> onFilePicked;

  const NotePicker({
    super.key,
    this.initialFile,
    required this.onFilePicked,
  });

  @override
  State<NotePicker> createState() => _NotePickerState();
}

class _NotePickerState extends State<NotePicker> {
  File? _selectedFile;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _selectedFile = widget.initialFile;
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      final path = result.files.single.path;
      final size = result.files.single.size;
      const maxFileSize = 15 * 1024 * 1024;

      if (path != null) {
        if (size <= maxFileSize) {
          final file = File(path);
          setState(() {
            _selectedFile = file;
            _errorText = null;
          });
          widget.onFilePicked(file);
        } else {
          setState(() {
            _errorText = Translation.of(context)!.translate("notePicker.body");
          });
          widget.onFilePicked(null);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fileName =
    _selectedFile != null ? _selectedFile!.path.split('/').last : Translation.of(context)!.translate("notePicker.noFile");

    return GestureDetector(
      onTap: _pickFile,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: theme.colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.attach_file,
                color: theme.colorScheme.onSecondaryContainer,
                size: 30,
              ),
              const SizedBox(height: 12),
              Text(
                fileName,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSecondaryContainer,
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              if (_errorText != null) ...[
                const SizedBox(height: 8),
                Text(
                  _errorText!,
                  style: TextStyle(color: theme.colorScheme.error),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 12),
              Text(
                Translation.of(context)!.translate("notePicker.noFile"),
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
