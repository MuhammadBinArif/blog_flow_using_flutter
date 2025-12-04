import 'package:blog_app_flutter/pages/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagePickerScreen extends StatefulWidget {
  final void Function(File?)? onImageSelected;
  const ImagePickerScreen({super.key, this.onImageSelected});

  @override
  _ImagePickerScreenState createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  File? selectedImage;
  final ImagePicker _picker = ImagePicker();

  // Method to pick image from camera
  Future<void> _pickImageFromCamera() async {
    try {
      final image = await ImageHelper.pickImageFromCamera();
      if (image != null) {
        setState(() {
          selectedImage = image;
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
          selectedImage = image;
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
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;
    return Container(
      width: width * 0.8,
      height: height * 0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: selectedImage != null
            ? Colors.transparent
            : Color.fromARGB(255, 226, 234, 134),
        border: selectedImage != null
            ? null
            : Border.all(color: Color(0xFF606c38)),
      ),
      child: selectedImage != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                selectedImage!,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, color: Colors.red, size: 40),
                      SizedBox(height: 8),
                      Text(
                        "Failed to load image",
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      TextButton(
                        onPressed: _showImagePickerDialog,
                        child: Text("Try Again"),
                      ),
                    ],
                  );
                },
              ),
            )
          : Center(
              child: TextButton(
                onPressed: _showImagePickerDialog,
                child: Text(
                  "Click here to add an image",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF283618),
                  ),
                ),
              ),
            ),

      // // When image is picked, call
      // onImageSelectected?.call(selectedImage),
    );
  }
}

/***
 * 
 *     // Scaffold(
    //   appBar: AppBar(title: Text('Image Picker')),
    //   body:
    //   Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         // Display selected image
    //         _selectedImage != null
    //             ? Image.file(
    //                 _selectedImage!,
    //                 height: 300,
    //                 width: 300,
    //                 fit: BoxFit.cover,
    //               )
    //             : Container(
    //                 height: 300,
    //                 width: 300,
    //                 color: Colors.grey[300],
    //                 child: Icon(
    //                   Icons.image,
    //                   size: 100,
    //                   color: Colors.grey[600],
    //                 ),
    //               ),

    //         SizedBox(height: 20),

    //         // Buttons
    //         // ElevatedButton.icon(
    //         //   onPressed: _pickImageFromGallery,
    //         //   icon: Icon(Icons.photo_library),
    //         //   label: Text('Pick from Gallery'),
    //         // ),

    //         // SizedBox(height: 10),

    //         // ElevatedButton.icon(
    //         //   onPressed: _pickImageFromCamera,
    //         //   icon: Icon(Icons.camera_alt),
    //         //   label: Text('Take a Photo'),
    //         // ),
    //       ],
    //     ),
    //   ),
    // );
 * 
 * 
 */
