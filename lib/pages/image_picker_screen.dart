import 'package:blog_app_flutter/pages/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({super.key});

  @override
  _ImagePickerScreenState createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  // Method to pick image from camera
  Future<void> _pickImageFromCamera() async {
    try {
      final image = await ImageHelper.pickImageFromCamera();
      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
        Navigator.of(context).pop(); // Close the dialog
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Failed to capture image: $e"),
        ),
      );
    }
  }

  // Pick image from gallery
  // Future<void> pickImageFromGallery() async {
  //   final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

  //   if (image != null) {
  //     setState(() {
  //       _selectedImage = File(image.path);
  //     });
  //   }
  // }

  // Method to pick image from gallery
  Future<void> _pickImageFromGallery() async {
    try {
      final image = await ImageHelper.pickImageFromGallery();
      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
        Navigator.of(context).pop(); // Close the dialog
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Failed to pick image: $e"),
        ),
      );
    }
  }

  //  // Pick image from camera
  // Future<void> pickImageFromCamera() async {
  //   final XFile? image = await _picker.pickImage(source: ImageSource.camera);

  //   if (image != null) {
  //     setState(() {
  //       _selectedImage = File(image.path);
  //     });
  //   }
  // }

  // Method to show image picker dialog
  void _showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Pick an image',
          style: TextStyle(color: Color(0xFF606c38)),
        ),
        content: Text(
          'Pick image to show in your blog post.',
          style: TextStyle(color: Color(0xFF606c38)),
        ),
        backgroundColor: Color(0xFFecf39e),
        actions: [
          ElevatedButton(
            onPressed: _pickImageFromCamera,
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF606c38)),
            child: Text("Camera", style: TextStyle(color: Color(0xFFecf39e))),
          ),
          ElevatedButton(
            onPressed: _pickImageFromGallery,
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF606c38)),
            child: Text("Gallery", style: TextStyle(color: Color(0xFFecf39e))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image Picker')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display selected image
            _selectedImage != null
                ? Image.file(
                    _selectedImage!,
                    height: 300,
                    width: 300,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 300,
                    width: 300,
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.image,
                      size: 100,
                      color: Colors.grey[600],
                    ),
                  ),

            SizedBox(height: 20),

            // Buttons
            // ElevatedButton.icon(
            //   onPressed: _pickImageFromGallery,
            //   icon: Icon(Icons.photo_library),
            //   label: Text('Pick from Gallery'),
            // ),

            // SizedBox(height: 10),

            // ElevatedButton.icon(
            //   onPressed: _pickImageFromCamera,
            //   icon: Icon(Icons.camera_alt),
            //   label: Text('Take a Photo'),
            // ),
          ],
        ),
      ),
    );
  }
}
