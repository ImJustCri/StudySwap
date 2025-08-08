import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ThumbnailPicker extends StatefulWidget {
  final File? initialImage;
  final ValueChanged<File?> onImagePicked;

  const ThumbnailPicker({
    super.key,
    this.initialImage,
    required this.onImagePicked,
  });

  @override
  State<ThumbnailPicker> createState() => _ThumbnailPickerState();
}

class _ThumbnailPickerState extends State<ThumbnailPicker> {
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _selectedImage = widget.initialImage;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile =
    await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      setState(() {
        _selectedImage = file;
      });
      widget.onImagePicked(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 296,
        decoration: BoxDecoration(
          color: theme.colorScheme.secondaryContainer,
        ),
        clipBehavior: Clip.antiAlias,
        child: _selectedImage == null
            ? Center(
          child: Icon(
            Icons.upload,
            size: 80,
            color: theme.colorScheme.onSecondaryContainer,
          ),
        )
            : Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 296,
        ),
      ),
    );
  }
}
