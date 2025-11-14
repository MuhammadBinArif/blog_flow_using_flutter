import 'package:blog_app_flutter/widgets/add_blog_bottom_sheet.dart';
import 'package:flutter/material.dart';

class AddBlogContainer extends StatefulWidget {
  const AddBlogContainer({super.key});

  @override
  State<AddBlogContainer> createState() => _AddBlogContainerState();
}

class _AddBlogContainerState extends State<AddBlogContainer> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: GestureDetector(
        onTap: () {
          // ✅ FIXED: Use showModalBottomSheet directly
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => AddBlogBottomSheet(),
          );
        },
        child: Card(
          elevation: 5,
          color: Color.fromARGB(255, 69, 93, 42),
          child: Container(
            margin: EdgeInsets.all(4),
            width: width * 0.89,
            height: height * 0.06,
            decoration: BoxDecoration(
              border: BoxBorder.all(
                color: Color(0xFF283618),
                style: BorderStyle.solid,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
              color: Color(0xFFecf39e),
            ),
            child: Center(
              child: Text(
                "Click to add a blog",
                style: TextStyle(
                  color: Color(0xFF283618),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


// GestureDetector(
              //   child: Container(
              //     // margin: EdgeInsets.only(top: 5, bottom: 5, left: 40, right: 50),
              //     width: width * 0.4,
              //     height: height * 0.04,
              //     decoration: BoxDecoration(
              //       color: Color(0xFF283618),
              //       borderRadius: BorderRadius.circular(10),
              //     ),

              //     child: Center(
              //       child: const Text(
              //         "Click to add a blog",
              //         style: TextStyle(color: Color(0xFFecf39e)),
              //       ),
              //     ),
              //   ),
              // ),