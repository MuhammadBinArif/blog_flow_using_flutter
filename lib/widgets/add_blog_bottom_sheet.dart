import 'dart:io' show File;

import 'package:blog_app_flutter/model/blog_model.dart';
import 'package:blog_app_flutter/pages/image_picker_screen.dart';
import 'package:blog_app_flutter/providers/blog_provider.dart';
import 'package:blog_app_flutter/widgets/form_field_bottom_sheet.dart';
import 'package:blog_app_flutter/widgets/blog_content_text_field_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddBlogBottomSheet extends StatefulWidget {
  const AddBlogBottomSheet({super.key});

  @override
  State<AddBlogBottomSheet> createState() => _AddBlogBottomSheetState();
}

class _AddBlogBottomSheetState extends State<AddBlogBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _authorNameController = TextEditingController();
  final _blogContentController = TextEditingController();

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

  String? _validateField(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter $fieldName';
    }
    return null;
  }

  void _addToBlogList() async {
    if (_isLoading) return;

    bool isValid = _formKey.currentState?.validate() ?? false;

    if (isValid) {
      setState(() {
        _isLoading = true;
      });

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) =>
            Center(child: CircularProgressIndicator(color: Color(0xFF606c38))),
      );

      try {
        if (_selectedImage == null) {
          Navigator.of(context).pop();
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
        String imageUrl = await provider.uploadImage(_selectedImage!);

        final uuid = Uuid();
        BlogModel newBlog = BlogModel(
          id: uuid.v4(),
          title: _titleController.text,
          subtitle: _subtitleController.text,
          authorName: _authorNameController.text,
          blogContent: _blogContentController.text,
          imagePath: imageUrl,
          authorId: uuid.v4(),
        );

        await provider.addBlog(newBlog);

        Navigator.of(context).pop(); // Close loading
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

        _clearForm();
      } catch (e) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text("Error: ${e.toString()}"),
            duration: Duration(seconds: 3),
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

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

    // Wrap everything with AnimatedPadding + SingleChildScrollView
    return AnimatedPadding(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        reverse: true, // Scrolls to keep focused field visible
        child: Container(
          width: width,
          // REMOVED fixed height: height * 0.8
          // Now it expands naturally with keyboard
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            color: const Color.fromARGB(255, 32, 73, 70),
          ),
          child: Container(
            margin: EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: const Color(0xFFffffff),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, top: 20, right: 10),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Critical: allows shrinking
                  children: [
                    // Title field
                    FormFieldBottomSheet(
                      controller: _titleController,
                      hintText: "Title",
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      validator: (value) => _validateField(value, 'title'),
                    ),
                    SizedBox(height: height * 0.02),

                    // Subtitle field
                    FormFieldBottomSheet(
                      controller: _subtitleController,
                      hintText: "Subtitle",
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      validator: (value) => _validateField(value, 'subtitle'),
                    ),
                    SizedBox(height: height * 0.02),

                    // Author field
                    FormFieldBottomSheet(
                      controller: _authorNameController,
                      hintText: "Author name",
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      validator: (value) =>
                          _validateField(value, 'author name'),
                    ),
                    SizedBox(height: height * 0.02),

                    // Image picker
                    ImagePickerScreen(
                      onImageSelected: (File? image) {
                        setState(() {
                          _selectedImage = image;
                        });
                      },
                    ),
                    SizedBox(height: height * 0.02),

                    // Remove image button
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

                    // Blog content
                    BlogContentTextFieldBottomSheet(
                      validator: (value) =>
                          _validateField(value, 'Blog content'),
                      controller: _blogContentController,
                      hintText: "Blog content",
                    ),
                    SizedBox(height: height * 0.02),

                    // Submit button
                    GestureDetector(
                      onTap: _isLoading ? null : _addToBlogList,
                      child: Container(
                        width: width * 0.6,
                        height: height * 0.06,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: _isLoading
                              ? Colors.grey
                              : const Color.fromARGB(255, 32, 73, 70),
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
                                    color: const Color(0xFFd9d9d9),
                                    fontSize: 22,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.04), // Extra bottom padding
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
