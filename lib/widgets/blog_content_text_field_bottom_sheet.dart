import 'package:flutter/material.dart';

class BlogContentTextFieldBottomSheet extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  const BlogContentTextFieldBottomSheet({
    super.key,
    required this.controller,
    required this.hintText,
    required this.validator,
    required Null Function(dynamic value) onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height - kToolbarHeight;
    return Container(
      height: height * 0.2,
      padding: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 226, 234, 134),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              validator: validator,
              cursorColor: const Color(0xFF90a955),
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: const Color(0xFF283618),
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              maxLines: null,
            ),
          ],
        ),
      ),
    );
  }
}
