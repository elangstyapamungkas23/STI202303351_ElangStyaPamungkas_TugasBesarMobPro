// lib/utils/image_utils.dart
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageUtils {
  static final ImagePicker _picker = ImagePicker();

  static Future<File?> pickFromGallery() async {
    final XFile? f = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        maxHeight: 1200,
        imageQuality: 85);
    if (f == null) return null;
    return File(f.path);
  }

  static Future<File?> pickFromCamera() async {
    final XFile? f = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1600,
        maxHeight: 1200,
        imageQuality: 85);
    if (f == null) return null;
    return File(f.path);
  }
}
