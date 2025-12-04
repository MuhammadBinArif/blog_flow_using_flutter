import 'package:blog_app_flutter/model/blog_model.dart';
import 'package:blog_app_flutter/pages/main_page.dart';
import 'package:blog_app_flutter/widgets/add_blog_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class SecondaryPage extends StatefulWidget {
  final BlogModel blog;
  const SecondaryPage({super.key, required this.blog});

  @override
  State<SecondaryPage> createState() => _SecondaryPageState();
}

class _SecondaryPageState extends State<SecondaryPage> {
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
      backgroundColor: Color(0xFF90a955),
      //  Color(0xFFdda15e),
      // Color.fromARGB(255, 151, 202, 219),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => MainPage()));
          },
          child: Icon(
            Icons.arrow_back,
            color: Color(0xFFecf39e),
            //  Color(0xFFfefae0),
          ),
        ),
        title: const Text(
          "𝓡𝓮𝓪𝓭𝓲𝓷𝓰 𝓪𝓻𝓮𝓪",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color(0xFFecf39e),
            //  Color(0xFFfefae0),
          ),
        ),
        backgroundColor: Color(0xFF283618),
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
                //   """
                // Time management is a fundamental skill that enables individuals to use their time effectively and productively, leading to greater success in both personal and professional life.
                //  Every person has the same twenty-four hours each day, and how these hours are allocated determines the level of achievement and overall well-being.
                //  Effective time management involves planning, organizing, and prioritizing tasks based on their importance and urgency, which helps in maximizing productivity and minimizing stress.
                //  It is particularly crucial for students, who must balance academic responsibilities, extracurricular activities, and personal development within a limited timeframe.
                //  By creating a practical schedule or timetable, individuals can allocate appropriate time to each activity, ensuring that essential tasks such as studying, sleeping, and exercising are not neglected.
                //  Prioritization is key; focusing on high-impact tasks first allows for better progress toward short-term and long-term goals.
                //  For instance, identifying the most productive time of day—often early morning after a good night’s sleep—and dedicating it to challenging tasks can significantly enhance efficiency.
                //  A well-structured routine not only ensures punctuality and consistency but also fosters discipline, which is essential for long-term success.
                //  To manage time effectively, one should begin by listing all daily tasks, categorizing them by priority, and assigning specific time slots to each.
                //  This method prevents procrastination and reduces the likelihood of last-minute rushes, especially during exam periods.
                //  Eliminating distractions such as excessive television, social media, or unproductive conversations can free up valuable time for more meaningful activities.
                //  Moreover, incorporating regular breaks into the schedule helps maintain focus and mental energy, preventing burnout.
                //  It is equally important to include time for rest, relaxation, and social interaction, as these contribute to emotional well-being and overall life satisfaction.
                //  Neglecting these aspects can lead to stress, fatigue, and decreased performance.
                //  A balanced approach to time management ensures that work is completed efficiently while still allowing space for personal growth, hobbies, and family time.
                //  The benefits of good time management extend beyond productivity; they include improved self-confidence, better decision-making, and a stronger sense of control over one’s life.
                //  When individuals manage their time wisely, they are more likely to meet deadlines, achieve their goals, and experience a greater sense of accomplishment.
                //  In the professional world, time management is equally vital, as it enhances work quality, supports career advancement, and strengthens relationships through punctuality and reliability.
                //  Ultimately, time is an irreplaceable resource—once lost, it cannot be recovered.
                //  Therefore, valuing time and using it purposefully is not just a strategy for success but a necessity for a fulfilling life.
                //  By consistently applying time management techniques such as goal setting, task prioritization, routine building, and self-reflection, individuals can transform their daily lives, reduce stress, and unlock their full potential.
                //  In essence, mastering time management is not about doing more in less time, but about doing what matters most with greater focus and intention.
                // """,
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


/***
 * Padding(
              padding: EdgeInsets.only(right: width * 0.6),
              child: const Text(
                "Title",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: height * 0.007),
            Padding(
              padding: EdgeInsets.only(right: width * 0.55),
              child: const Text(
                "Subtitle",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(height: height * 0.02),
            Padding(
              padding: EdgeInsets.only(right: width * 0.47),
              child: const Text(
                "Author name",
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
            ),
 * 
 */