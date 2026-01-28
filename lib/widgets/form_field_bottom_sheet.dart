import 'package:flutter/material.dart';

class FormFieldBottomSheet extends StatelessWidget {
  final Color cursorColor;
  final String hintText;
  final Color hintStyleColor;
  final double fontSize;
  final FontWeight fontWeight;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Function(String?)? onFieldSubmitted;

  const FormFieldBottomSheet({
    super.key,
    this.cursorColor = const Color(0xFF90a955),
    required this.hintText,
    this.hintStyleColor = const Color.fromARGB(255, 32, 73, 70),
    required this.fontSize,
    required this.fontWeight,
    required this.controller,
    this.validator,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;
    return Container(
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.only(left: 10),
      width: width * 0.9,
      height: height * 0.06,
      decoration: BoxDecoration(
        color: const Color(0xFFd9d9d9),
        // Color.fromARGB(255, 226, 234, 134),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        validator: validator,
        controller: controller,
        cursorColor: cursorColor,
        onFieldSubmitted: onFieldSubmitted,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            color: hintStyleColor,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ),
      ),
    );
  }
}
