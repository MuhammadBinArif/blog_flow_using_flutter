import 'package:flutter/material.dart';

class AddBlogTextField extends StatefulWidget {
  const AddBlogTextField({super.key});

  @override
  State<AddBlogTextField> createState() => _AddBlogTextFieldState();
}

class _AddBlogTextFieldState extends State<AddBlogTextField> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;
    return Scaffold(
      body: Container(
        width: width,
        height: height * 0.1,
        decoration: BoxDecoration(
          color: Color(0xFF606c38),
          // Color.fromARGB(228, 75, 134, 143),
          // const Color.fromARGB(255, 5, 46, 80),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: width * 0.035),
            Container(
              padding: EdgeInsets.only(left: 20),
              width: width * 0.77,
              height: height * 0.05,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFFecf39e),
                // Color.fromARGB(255, 233, 237, 183),
                //  Color(0xFFfefae0),
                // Colors.white,
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Write your blog here...",
                ),
              ),
            ),
            SizedBox(width: width * 0.03),
            // Button to send a blog you entered
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      "You have successfully added a blog!",
                      style: TextStyle(color: Color(0xFFecf39e)),
                    ),
                    backgroundColor: Color(0xFF606c38),
                  ),
                );
              },

              child: Container(
                width: width * 0.12,
                height: height * 0.05,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFF283618),
                  //  Color(0xFF014f86),
                  //  const Color.fromARGB(71, 255, 255, 255),
                ),
                child: Center(
                  child: Icon(
                    Icons.send,
                    size: 30,
                    color: Color(0xFFecf39e),
                    //  Color(0xFFfefae0),
                    //  const Color.fromARGB(195, 255, 255, 255),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
