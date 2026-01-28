import 'package:blog_app_flutter/model/blog_model.dart';

import 'package:blog_app_flutter/widgets/add_blog_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DetailPage extends StatefulWidget {
  final BlogModel blog;
  const DetailPage({super.key, required this.blog});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  AddBlogBottomSheet blogBottomSheet = AddBlogBottomSheet();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;
    double rating = 3.5;

    // Access all blog data through widget.blog
    final blog = widget.blog;

    return Scaffold(
      backgroundColor: const Color(0xFFffffff),
      // Color(0xFF90a955),
      //  Color(0xFFdda15e),
      // Color.fromARGB(255, 151, 202, 219),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back,
            color: const Color(0xFFd9d9d9),
            //  Color(0xFFecf39e),
            //  Color(0xFFfefae0),
          ),
        ),
        title: const Text(
          "𝓡𝓮𝓪𝓭𝓲𝓷𝓰 𝓪𝓻𝓮𝓪",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color(0xFFd9d9d9),
            //  Color(0xFFecf39e),
            //  Color(0xFFfefae0),
          ),
        ),
        backgroundColor: const Color(0xFF183a37),
        // Color(0xFF283618),
        // Color.fromARGB(255, 1, 138, 190),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height * 0.1),
            Container(
              margin: EdgeInsets.only(left: width * 0.1),
              width: width * 0.8,
              height: height * 0.3,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                // image: DecorationImage(
                //   image: AssetImage("assets/images/time.jpg"),
                // ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: blog.imagePath.isNotEmpty
                    ? Image.network(
                        blog.imagePath, // Use blog image URL
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            "assets/images/time.jpg", // Fal back image
                            fit: BoxFit.cover,
                          );
                        },
                      )
                    : Image.asset(
                        "assets/images/time.jpg", // Default if no image
                        fit: BoxFit.cover,
                      ),
                //  Image(
                //   image: AssetImage("assets/images/time.jpg"),
                //   fit: BoxFit.cover,
                // ),
              ),
              //  Image.asset("assets/images/time.jpg", fit: BoxFit.fill),
            ),
            SizedBox(height: height * 0.05),
            Padding(
              padding: EdgeInsets.only(left: width * 0.1),
              child: Text(
                blog.title,
                // "Title: ${blog.title}",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: height * 0.001),
            Padding(
              padding: EdgeInsets.only(left: width * 0.1),
              child: Text(
                blog.subtitle,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: height * 0.02),
            Row(
              children: [
                SizedBox(width: width * 0.1),
                RatingBar.builder(
                  initialRating: rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) =>
                      Icon(Icons.star, color: Colors.amber),
                  onRatingUpdate: (rating) {
                    setState(() {
                      rating = rating;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: height * 0.02),
            Padding(
              padding: EdgeInsets.only(left: width * 0.1),
              child: Text(
                "Author: ${blog.authorName}",
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: width * 0.1, right: width * 0.1),
              child: Text(
                blog.blogContent,
                textAlign: TextAlign.justify,
                textDirection: TextDirection.ltr,
                maxLines: 150,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
