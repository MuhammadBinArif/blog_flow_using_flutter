import 'package:blog_app_flutter/pages/image_helper.dart';
import 'package:flutter/material.dart';

import 'dart:io';

class ImagePickerScreen extends StatefulWidget {
  final void Function(File?)? onImageSelected;
  const ImagePickerScreen({super.key, this.onImageSelected});

  @override
  _ImagePickerScreenState createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  File? selectedImage;

  // Method to pick image from camera
  Future<void> _pickImageFromCamera() async {
    try {
      final image = await ImageHelper.pickImageFromCamera();
      if (image != null) {
        setState(() {
          selectedImage = image;
        });
        widget.onImageSelected?.call(selectedImage); // Call the callback
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

  // Method to pick image from gallery
  Future<void> _pickImageFromGallery() async {
    try {
      final image = await ImageHelper.pickImageFromGallery();
      if (image != null) {
        setState(() {
          selectedImage = image;
        });
        widget.onImageSelected?.call(selectedImage); // Call the callback
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

  // Method to show image picker dialog
  void _showImagePickerDialog() {
    showDialog(
      context: context,
      animationStyle: AnimationStyle(
        curve: Curves.easeOutBack, // Nice bounce effect at the end
        duration: Duration(milliseconds: 400),
        reverseCurve: Curves.easeInBack, // Exit animation
        reverseDuration: Duration(milliseconds: 300),
      ),
      builder: (context) => AlertDialog(
        title: Text(
          'Pick an image',
          style: TextStyle(
            color: const Color.fromARGB(255, 32, 73, 70),
            // const Color(0xFFffffff),
            //  Color(0xFF606c38),
          ),
        ),
        content: Text(
          'Pick image to show in your blog post.',
          style: TextStyle(
            color: const Color.fromARGB(255, 32, 73, 70),
            // const Color.fromARGB(255, 32, 73, 70),const Color(0xFFffffff),

            // Color(0xFF606c38),
          ),
        ),
        backgroundColor: const Color(0xFFd9d9d9),
        //  Color(0xFFecf39e),
        actions: [
          ElevatedButton(
            onPressed: _pickImageFromCamera,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 32, 73, 70),

              // Color(0xFF606c38)
            ),
            child: Text(
              "Camera",
              style: TextStyle(
                color: const Color(0xFFffffff),

                // Color(0xFFecf39e),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _pickImageFromGallery,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 32, 73, 70),

              // Color(0xFF606c38),
            ),
            child: Text(
              "Gallery",
              style: TextStyle(
                color: const Color(0xFFffffff),
                // Color(0xFFecf39e),
              ),
            ),
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
            : const Color(0xFFd9d9d9),
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
                    color: const Color.fromARGB(255, 32, 73, 70),
                    // const Color(0xFF283618),
                  ),
                ),
              ),
            ),
    );
  }
}
