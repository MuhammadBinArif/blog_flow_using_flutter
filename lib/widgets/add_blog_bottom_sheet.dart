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
import 'package:uuid/uuid.dart';

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
  bool _isLoading = false;

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

  void _addToBlogList() async {
    // Prevent double tap
    if (_isLoading) return;

    // Validate form
    if (_formKey.currentState?.validate() ?? false) {
      // Set loading state
      setState(() {
        _isLoading = true;
      });

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) =>
            Center(child: CircularProgressIndicator(color: Color(0xFF606c38))),
      );

      try {
        // ✅ CHECK FOR IMAGE
        if (_selectedImage == null) {
          Navigator.of(context).pop(); // Remove loading dialog
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text("Please select an image"),
            ),
          );
          return;
        }

        final provider = Provider.of<BlogProvider>(context, listen: false);

        // ✅ UPLOAD IMAGE TO CLOUDINARY
        print("Uploading image to Cloudinary...");
        String imageUrl = await provider.uploadImage(_selectedImage!);
        print("Image uploaded. URL: $imageUrl");

        // ✅ CREATE BLOG MODEL
        final uuid = Uuid();
        BlogModel newBlog = BlogModel(
          id: uuid.v4(),
          title: _titleController.text,
          subtitle: _subtitleController.text,
          authorName: _authorNameController.text,
          blogContent: _blogContentController.text,
          imagePath: imageUrl,
        );

        print("Creating blog: ${newBlog.title}");

        // ✅ SAVE TO FIRESTORE
        await provider.addBlog(newBlog);
        print("Blog saved to Firestore");

        // ✅ SUCCESS - CLEAN UP
        Navigator.of(context).pop(); // Remove loading dialog
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

        // ✅ CLEAR FORM
        _clearForm();
      } catch (e) {
        // ✅ ERROR HANDLING
        print("Error in _addToBlogList: $e");

        Navigator.of(context).pop(); // Remove loading dialog

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text("Error: ${e.toString()}"),
            duration: Duration(seconds: 3),
          ),
        );
      } finally {
        // ✅ ALWAYS RESET LOADING STATE
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      // Form validation failed
      print("Form validation failed");
    }
  }

  // ✅ ADD CLEAR FORM METHOD
  void _clearForm() {
    _titleController.clear();
    _subtitleController.clear();
    _authorNameController.clear();
    _blogContentController.clear();
    setState(() {
      _selectedImage = null;
    });
  }

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
            child: SingleChildScrollView(
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
                  SizedBox(height: height * 0.02),

                  // Container to show selected image
                  ImagePickerScreen(
                    onImageSelected: (File? image) {
                      setState(() {
                        _selectedImage = image;
                      });
                    },
                  ),

                  SizedBox(height: height * 0.02),

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
                  TextFieldBottomSheet(
                    controller: _blogContentController,
                    hintText: "Blog content",
                  ),
                  SizedBox(height: height * 0.02),
                  GestureDetector(
                    onTap: _isLoading
                        ? null
                        : _addToBlogList, // Disable when loading
                    child: Container(
                      width: width * 0.6,
                      height: height * 0.06,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: _isLoading
                            ? Colors.grey
                            : Color(0xFF606c38), // Grey when loading
                      ),
                      child: Center(
                        child: _isLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Color(0xFFecf39e),
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                "Done",
                                style: TextStyle(
                                  color: Color(0xFFecf39e),
                                  fontSize: 22,
                                ),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                ],
              ),
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
