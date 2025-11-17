import 'package:blog_app_flutter/model/blog_model.dart';
import 'package:blog_app_flutter/providers/blog_provider.dart';
import 'package:blog_app_flutter/widgets/add_blog_container.dart';
import 'package:blog_app_flutter/widgets/my_blog_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

@override
Widget build(BuildContext context) {
  return Container(); // Your widget content
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeBlogs();
    });
  }

  void _initializeBlogs() {
    final blogProvider = Provider.of<BlogProvider>(context, listen: false);
    blogProvider.listenToBlogs();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;
    int currentIndex = 0;
    return Scaffold(
      backgroundColor: Color(0xFF90a955),
      // Color(0xFFdda15e),
      //  Color(0xFF98c1d9),
      appBar: AppBar(
        title: const Text(
          "𝔅𝔩𝔬𝔤𝔰 𝔄𝔭𝔭",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color(0xFFecf39e),
            //  Color(0xFFfefae0),
            //  const Color.fromARGB(195, 255, 255, 255),
          ),
        ),
        centerTitle: true,

        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: Color(0xFFecf39e)),
            onPressed: () async {
              // First show the dialog
              await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                    'Information',
                    style: TextStyle(color: Color(0xFF606c38)),
                  ),
                  content: Text(
                    'This is an important information dialog.',
                    style: TextStyle(color: Color(0xFF606c38)),
                  ),
                  backgroundColor: Color(0xFFecf39e),
                  //  Color(0xFF283618),
                  // Color(0xFF606c38),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'OK',
                        style: TextStyle(color: Color.fromARGB(255, 27, 45, 7)),
                      ),
                    ),
                  ],
                ),
              );

              // Then show snackbar after dialog is closed
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Dialog closed',
                    style: TextStyle(color: Color(0xFFecf39e)),
                  ),
                  duration: Duration(seconds: 2),
                  backgroundColor: Color(0xFF606c38),
                ),
              );
            },
          ),
        ],
        // Padding(
        //       padding: EdgeInsets.only(right: width * 0.025),
        //       child: Icon(Icons.menu, color: Color(0xFFfefae0)),
        //     ),
        backgroundColor: Color(0xFF283618),
        // Color(0xFF15616d),
        // Color(0xFF3d5a80),
        // Color.fromARGB(255, 1, 138, 190),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // SizedBox(height: height * 0.03),
            AddBlogContainer(),

            // width: width,
            //   height: height * 0.67,

            // Initialize listening your blog listing screen
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: Provider.of<BlogProvider>(context).blogs.length,
              itemBuilder: (context, index) {
                return MyBlogCard(
                  title: blog[index].title,
                  subtitle: blog[index].subtitle,
                  authorName: blog[index].authorName,
                );

                // ListView(
                //   children: [
                //     MyBlogCard(
                //       title: blog[index].title,
                //       subtitle: blog[index].subtitle,
                //       authorName: blog[index].authorName,
                //     ),
                //     // MyBlogCard(
                //     //   title: blog[index].title,
                //     //   subtitle: blog[index].subtitle,
                //     //   authorName: blog[index].authorName,
                //     // ),
                //     // MyBlogCard(
                //     //   title: blog[index].title,
                //     //   subtitle: blog[index].subtitle,
                //     //   authorName: blog[index].authorName,
                //     // ),
                //     // MyBlogCard(
                //     //   title: blog[index].title,
                //     //   subtitle: blog[index].subtitle,
                //     //   authorName: blog[index].authorName,
                //     // ),
                //     // MyBlogCard(
                //     //   title: blog[index].title,
                //     //   subtitle: blog[index].subtitle,
                //     //   authorName: blog[index].authorName,
                //     // ),
                //   ],
                // );

                // MyBlogCard(
                //   title: "How to master your time",
                //   subtitle:
                //       "The secret to time management is simple: Jedi time tricks.",
                //   authorName: "Oliver Emberton",
                // ),
                // MyBlogCard(
                //   title:
                //       "The problem isn’t that life is unfair – it’s your broken idea of fairness",
                //   subtitle:
                //       "Unless you’re winning, most of life will seem hideously unfair to you.",
                //   authorName: "Oliver Emberton",
                // ),
              },
            ),
          ],
        ),
      ),

      // Bottom navigation bar
      bottomNavigationBar: NavigationBar(
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(
            color: Color(0xFFecf39e),
            // Colors.white,
          ),
        ),
        selectedIndex: currentIndex,
        indicatorColor: Color(0xFF606c38),
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home, color: Color(0xFFfefae0), size: 30),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(Icons.search, color: Color(0xFFfefae0), size: 30),
            label: "Search",
          ),
          NavigationDestination(
            icon: Icon(Icons.book, color: Color(0xFFfefae0), size: 30),
            label: "Favourite",
          ),
          NavigationDestination(
            icon: Icon(Icons.person, color: Color(0xFFfefae0), size: 30),
            label: "Profile",
          ),
        ],
        backgroundColor: Color(0xFF283618),

        // Color(0xFF15616d),
        //  Color(0xFF468faf),
        //  Color.fromARGB(255, 1, 138, 190),
        elevation: 3,
        // labelTextStyle: TextStyle(color: Colors.black),
        // onDestinationSelected: (index) {
        //   setState(() {
        //     _currentIndex = index;
        //   });
        // },
        animationDuration: const Duration(milliseconds: 500),
      ),
    );
  }
}
