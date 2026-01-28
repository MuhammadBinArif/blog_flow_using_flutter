import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageHelper {
  static final ImagePicker _picker = ImagePicker();

  static Future<File?> pickImageFromCamera() async {
    try {
      // Critical: Check permission first
      final status = await Permission.camera.request();
      if (status.isDenied) return null;

      final image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1200, // Prevent memory crash
        maxHeight: 1200,
        imageQuality: 85,
      );

      return image != null ? File(image.path) : null;
    } catch (e) {
      print('Camera error: $e');
      return null;
    }
  }

  static Future<File?> pickImageFromGallery() async {
    try {
      final status = await Permission.photos.request();
      if (status.isDenied) return null;

      final image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      return image != null ? File(image.path) : null;
    } catch (e) {
      print('Gallery error: $e');
      return null;
    }
  }
}
