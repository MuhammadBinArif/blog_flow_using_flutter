import 'package:blog_app_flutter/model/blog_model.dart';
import 'package:blog_app_flutter/widgets/form_field_bottom_sheet.dart';
import 'package:flutter/material.dart';

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

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _authorNameController.dispose();
    super.dispose();
  }

  // Simple validation function
  String? _validateField(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter $fieldName'; // This shows below the field
    }
    return null; // Return null if valid
  }

  void _addToBlogList() {
    // This will automatically validate all fields and show errors
    if (_formKey.currentState!.validate()) {
      // Only executed if ALL fields are valid
      BlogModel newBlog = BlogModel(
        title: _titleController.text,
        subtitle: _subtitleController.text,
        authorName: _authorNameController.text,
      );

      blog.add(newBlog);

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color(0xFF606c38),
          content: Text(
            "Blog added successfully!",
            style: TextStyle(color: Color(0xFFecf39e)),
          ),
        ),
      );
    }
    // If validation fails, errors automatically show below each field
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;

    return Container(
      width: width,
      height: height * 0.6, // Increased height for error messages
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
                ),

                SizedBox(height: height * 0.175),
                GestureDetector(
                  onTap: _addToBlogList, // This will trigger validation
                  child: Container(
                    width: width * 0.4,
                    height: height * 0.06,
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
