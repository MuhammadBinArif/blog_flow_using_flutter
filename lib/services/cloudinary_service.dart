import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_flutter/cloudinary_context.dart';
import 'package:cloudinary_flutter/cloudinary_object.dart';
import 'package:http/http.dart' as http;

class CloudinaryService {
  static const String cloudName = "dqvgt4mpm";
  static const String uploadPreset = "blog_app_upload";

  // Simple upload method that definitely works
  static Future<String?> uploadImage(File imageFile) async {
    try {
      // 1. Create the upload URL
      final uploadUrl =
          'https://api.cloudinary.com/v1_1/$cloudName/image/upload';

      // 2. Create multipart request
      var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));

      // 3. Add upload preset
      request.fields['upload_preset'] = uploadPreset;

      // 4. Add the image file
      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );

      // 5. Send the request
      var response = await request.send();

      // 6. Get response data
      var responseData = await response.stream.bytesToString();
      var jsonData = jsonDecode(responseData);

      // 7. Check if successful
      if (response.statusCode == 200) {
        return jsonData['secure_url'];
      } else {
        print('Upload failed: ${jsonData['error']['message']}');
        return null;
      }
    } catch (e) {
      // ADD THIS CATCH CLAUSE
      print('Error uploading to Cloudinary: $e');
      return null;
    }
  }

  // static const String cloudName = "dqvgt4mpm";
  // static const String apiKey = "821488724375794";
  // static const String apiSecret = "hi0QjR91ZOdYR_G623fQKf8cU-w";
  // static const String uploadPresent = "blog_app_upload";
}
