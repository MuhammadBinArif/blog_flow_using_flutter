import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImageHelper {
  static Future<File?> pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);
    return image != null ? File(image.path) : null;
  }

  static Future<File?> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    return image != null ? File(image.path) : null;
  }
}
