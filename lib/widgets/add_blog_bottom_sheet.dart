import 'dart:io' show File;

import 'package:blog_app_flutter/model/blog_model.dart';
import 'package:blog_app_flutter/pages/image_helper.dart';
import 'package:blog_app_flutter/pages/image_picker_screen.dart';
import 'package:blog_app_flutter/providers/blog_provider.dart';
import 'package:blog_app_flutter/widgets/form_field_bottom_sheet.dart';
import 'package:blog_app_flutter/widgets/text_field_bottom_sheet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddBlogBottomSheet extends StatefulWidget {
  const AddBlogBottomSheet({super.key});

  @override
  State<AddBlogBottomSheet> createState() => _AddBlogBottomSheetState();
}

class _AddBlogBottomSheetState extends State<AddBlogBottomSheet> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _authorNameController = TextEditingController();
  final _blogContentController = TextEditingController();
  final ImagePickerScreen _pickImage = ImagePickerScreen();

  // Add this variable to store the selected image
  File? _selectedImage;

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _authorNameController.dispose();
    _blogContentController.dispose();
    super.dispose();
  }

  // Simple validation function
  String? _validateField(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter $fieldName'; // This shows below the field
    }
    return null; // Return null if valid
  }

  // // Method to pick image from camera
  // Future<void> _pickImageFromCamera() async {
  //   try {
  //     final image = await ImageHelper.pickImageFromCamera();
  //     if (image != null) {
  //       setState(() {
  //         _selectedImage = image;
  //       });
  //       Navigator.of(context).pop(); // Close the dialog
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         backgroundColor: Colors.red,
  //         content: Text("Failed to capture image: $e"),
  //       ),
  //     );
  //   }
  // }

  // // Method to pick image from gallery
  // Future<void> _pickImageFromGallery() async {
  //   try {
  //     final image = await ImageHelper.pickImageFromGallery();
  //     if (image != null) {
  //       setState(() {
  //         _selectedImage = image;
  //       });
  //       Navigator.of(context).pop(); // Close the dialog
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         backgroundColor: Colors.red,
  //         content: Text("Failed to pick image: $e"),
  //       ),
  //     );
  //   }
  // }

  void _addToBlogList() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final provider = Provider.of<BlogProvider>(context, listen: false);

        // ✅ Now this will work because uploadImage method exists
        String imageUrl = await provider.uploadImage(_selectedImage!);

        BlogModel newBlog = BlogModel(
          title: _titleController.text,
          subtitle: _subtitleController.text,
          authorName: _authorNameController.text,
          blogContent: _blogContentController.text,
          id: "",
          imagePath: imageUrl, // Add image path to your model
        );

        await provider.addBlog(newBlog); // Adds to Firestore and notifies

        Navigator.of(context).pop(); // Close bottom sheet
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Color(0xFF606c38),
            content: Text(
              "Blog added successfully!",
              style: TextStyle(color: Color(0xFFecf39e)),
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text("Failed to add blog: $e"),
          ),
        );
      }
    }
  }

  // void _addToBlogList() {
  //   // This will automatically validate all fields and show errors
  //   if (_formKey.currentState!.validate()) {
  //     // Only executed if ALL fields are valid
  //     BlogModel newBlog = BlogModel(
  //       title: _titleController.text,
  //       subtitle: _subtitleController.text,
  //       authorName: _authorNameController.text,
  //       id: '',
  //     );

  //     blog.add(newBlog);

  //     Navigator.of(context).pop();
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         backgroundColor: Color(0xFF606c38),
  //         content: Text(
  //           "Blog added successfully!",
  //           style: TextStyle(color: Color(0xFFecf39e)),
  //         ),
  //       ),
  //     );
  //   }
  //   // If validation fails, errors automatically show below each field
  // }

  // // Method to show image picker dialog
  // void _showImagePickerDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text(
  //         'Pick an image',
  //         style: TextStyle(color: Color(0xFF606c38)),
  //       ),
  //       content: Text(
  //         'Pick image to show in your blog post.',
  //         style: TextStyle(color: Color(0xFF606c38)),
  //       ),
  //       backgroundColor: Color(0xFFecf39e),
  //       actions: [
  //         ElevatedButton(
  //           onPressed: _pickImageFromCamera,
  //           style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF606c38)),
  //           child: Text("Camera", style: TextStyle(color: Color(0xFFecf39e))),
  //         ),
  //         ElevatedButton(
  //           onPressed: _pickImageFromGallery,
  //           style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF606c38)),
  //           child: Text("Gallery", style: TextStyle(color: Color(0xFFecf39e))),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;

    return Container(
      width: width,
      height: height * 0.8, // Increased height for error messages
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        color: Color(0xFF90a955),
      ),
      child: Container(
        margin: EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: Color(0xFFecf39e),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, top: 20, right: 10),
          child: Form(
            // Wrap with Form widget
            key: _formKey, // Attach the form key
            child: Column(
              children: [
                // Title field with validation
                FormFieldBottomSheet(
                  controller: _titleController,
                  hintText: "Title",
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  validator: (value) =>
                      _validateField(value, 'title'), // Add validator
                  onFieldSubmitted: (value) {
                    _formKey.currentState?.validate();
                  },
                ),
                SizedBox(height: height * 0.02),

                // Subtitle field with validation
                FormFieldBottomSheet(
                  controller: _subtitleController,
                  hintText: "Subtitle",
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  validator: (value) =>
                      _validateField(value, 'subtitle'), // Add validator
                  onFieldSubmitted: (value) {
                    _formKey.currentState?.validate();
                  },
                ),
                SizedBox(height: height * 0.02),

                // Author field with validation
                FormFieldBottomSheet(
                  controller: _authorNameController,
                  hintText: "Author name",
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  validator: (value) =>
                      _validateField(value, 'author name'), // Add validator
                  onFieldSubmitted: (value) {
                    _formKey.currentState?.validate();
                  },
                ),
                SizedBox(height: height * 0.01),

                // Container to show selected image
                ImagePickerScreen(
                  onImageSelected: (File? image) {
                    setState(() {
                      _selectedImage = image;
                    });
                  },
                ),

                // Container(
                //   width: width * 0.8,
                //   height: height * 0.4,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(10),
                //     color: _selectedImage != null
                //         ? Colors.transparent
                //         : Colors.blue,
                //     border: _selectedImage != null
                //         ? null
                //         : Border.all(color: Colors.grey),
                //   ),
                //   child: _selectedImage != null
                //       ? ClipRRect(
                //           borderRadius: BorderRadius.circular(10),
                //           child: Image.file(
                //             _selectedImage!,
                //             width: double.infinity,
                //             height: double.infinity,
                //             fit: BoxFit.fill,
                //             errorBuilder: (context, error, stackTrace) {
                //               return Column(
                //                 mainAxisAlignment: MainAxisAlignment.center,
                //                 children: [
                //                   Icon(
                //                     Icons.error,
                //                     color: Colors.red,
                //                     size: 40,
                //                   ),
                //                   SizedBox(height: 8),
                //                   Text(
                //                     "Failed to load image",
                //                     style: TextStyle(
                //                       color: Colors.red,
                //                       fontSize: 16,
                //                     ),
                //                   ),
                //                   SizedBox(height: 8),
                //                   TextButton(
                //                     onPressed: _showImagePickerDialog,
                //                     child: Text("Try Again"),
                //                   ),
                //                 ],
                //               );
                //             },
                //           ),
                //         )
                //       : Center(
                //           child: TextButton(
                //             onPressed: _showImagePickerDialog,
                //             child: Text(
                //               "Click here to add an image",
                //               style: TextStyle(
                //                 fontSize: 20,
                //                 fontWeight: FontWeight.w700,
                //                 color: Colors.white,
                //               ),
                //             ),
                //           ),
                //         ),
                // ),
                SizedBox(height: height * 0.003),

                // Remove image button (only show when image is selected)
                if (_selectedImage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedImage = null;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Text(
                        "Remove Image",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                // Text field for blog content
                // TextFieldBottomSheet(
                //   controller: _blogContentController,
                //   hintText: "Blog content",
                // ),
                SizedBox(height: height * 0.003),
                GestureDetector(
                  onTap: _addToBlogList, // This will trigger validation
                  child: Container(
                    width: width * 0.4,
                    height: height * 0.05,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFF606c38),
                    ),
                    child: Center(
                      child: Text(
                        "Done",
                        style: TextStyle(
                          color: Color(0xFFecf39e),
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/**
 * 
 *     // Elevated button to add an image
                // ElevatedButton(
                //   onPressed: () {
                //     setState(() {
                //       showDialog(
                //         context: context,
                //         builder: (context) => AlertDialog(
                //           title: Text(
                //             'Pick an image',
                //             style: TextStyle(color: Color(0xFF606c38)),
                //           ),
                //           content: Text(
                //             'Pick image to show in your blog post.',
                //             style: TextStyle(color: Color(0xFF606c38)),
                //           ),
                //           backgroundColor: Color(0xFFecf39e),
                //           actions: [
                //             ElevatedButton(
                //               onPressed: () async {
                //                 File? image =
                //                     await ImageHelper.pickImageFromCamera();
                //               },
                //               child: const Text("Add image from camera"),
                //             ),
                //             ElevatedButton(
                //               onPressed: () async {
                //                 File? image =
                //                     await ImageHelper.pickImageFromGallery();
                //               },
                //               child: const Text("Add image from gallery"),
                //             ),
                //             // TextButton(
                //             //   onPressed: () => Navigator.of(context).pop(),
                //             //   child: Text(
                //             //     'OK',
                //             //     style: TextStyle(
                //             //       color: Color.fromARGB(255, 27, 45, 7),
                //             //     ),
                //             //   ),
                //             // ),
                //           ],
                //         ),
                //       );
                //     });
                //   },
                //   child: const Text("Add an image"),
                // ),
                
             
 * 
 */
