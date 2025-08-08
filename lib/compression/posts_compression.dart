import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:uuid/uuid.dart';

class PostsCompressor {
  static Future<File> compressImage(File originalFile) async {
    final bytes = await originalFile.readAsBytes();

    // Decode image
    final image = img.decodeImage(bytes);
    if (image == null) {
      throw Exception('Failed to decode image');
    }

    // Only resize if height is greater than 592
    if (image.height > 592) {
      const int targetHeight = 592;
      final int targetWidth = (image.width * targetHeight / image.height).round();

      // Resize image
      final resizedImage = img.copyResize(image, height: targetHeight, width: targetWidth);

      // Encode to JPEG with quality 100%
      final compressedBytes = img.encodeJpg(resizedImage, quality: 100);

      // Write to a temporary file
      final tempDir = Directory.systemTemp;
      final compressedFilePath = '${tempDir.path}/${const Uuid().v4()}.jpg';
      final compressedFile = await File(compressedFilePath).writeAsBytes(compressedBytes);

      return compressedFile;
    } else {
      return originalFile;
    }
  }

}
