import 'package:blog_app_flutter/pages/favourite_page.dart';
import 'package:blog_app_flutter/providers/blog_provider.dart';
import 'package:blog_app_flutter/widgets/add_blog_container.dart';
import 'package:blog_app_flutter/widgets/my_blog_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ✅ ADD THE MISSING STATEFUL WIDGET CLASS
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<BlogProvider>(context, listen: false);
      provider.listenToBlogs();
    });
  }

  @override
  Widget build(BuildContext context) {
    final blogProvider = Provider.of<BlogProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFffffff),
      //  Color(0xFF3c6e71),

      //  Color(0xFF90a955),
      appBar: AppBar(
        title: const Text(
          "𝔅𝔩𝔬𝔤𝔰 𝔄𝔭𝔭",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color(0xFFd9d9d9),
            // Color(0xFFecf39e),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.menu,
              color: const Color(0xFFd9d9d9),
              // const Color(0xFFd9d9d9),
            ),
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                    'Information',
                    style: TextStyle(
                      color: const Color(0xFFffffff),
                      // const Color(0xFFd9d9d9),
                      // Color(0xFF606c38),
                    ),
                  ),
                  content: Text(
                    'This is an important information dialog.',
                    style: TextStyle(
                      color: const Color(0xFFffffff),
                      // Color(0xFF606c38),
                    ),
                  ),
                  backgroundColor: const Color.fromARGB(255, 32, 73, 70),
                  // const Color(0xFFffffff),
                  // Color(0xFFecf39e),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'OK',
                        style: TextStyle(
                          color: const Color(0xFFffffff),
                          fontSize: 20,
                          fontWeight: FontWeight.w500,

                          // Color.fromARGB(255, 27, 45, 7)
                        ),
                      ),
                    ),
                  ],
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Dialog closed',
                    style: TextStyle(
                      color: const Color(0xFFffffff),

                      // Color(0xFFecf39e)
                    ),
                  ),
                  duration: Duration(seconds: 2),
                  backgroundColor: const Color.fromARGB(255, 32, 73, 70),
                  // Color(0xFF606c38),
                ),
              );
            },
          ),
        ],
        backgroundColor: Color(0xFF183a37),
        // Color(0xFF283618),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AddBlogContainer(),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: blogProvider.blogs.length,
              itemBuilder: (context, index) {
                final blog = blogProvider.blogs[index];
                return MyBlogCard(blog: blog);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(
            color: const Color(0xFFd9d9d9),
            // Color(0xFFecf39e),
          ),
        ),
        selectedIndex: currentIndex,
        indicatorColor: const Color(0xFFd9d9d9),
        //  Color(0xFF606c38),
        onDestinationSelected: (index) {
          setState(() => currentIndex = index);

          // Navigate to different pages based on index
          if (index == 2) {
            // Assuming "Favourite" is index 2
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FavouritePage()),
            );
          }
        },

        // onDestinationSelected: (index) => setState(() => currentIndex = index),
        destinations: [
          NavigationDestination(
            icon: Icon(
              Icons.home,
              color: const Color.fromARGB(255, 32, 73, 70),
              size: 30,
            ),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(
              Icons.search,
              color: const Color.fromARGB(255, 32, 73, 70),
              size: 30,
            ),
            label: "Search",
          ),
          NavigationDestination(
            icon: Icon(
              Icons.book,
              color: const Color.fromARGB(255, 32, 73, 70),
              size: 30,
            ),
            label: "Favourite",
          ),
          NavigationDestination(
            icon: Icon(
              Icons.person,
              color: const Color.fromARGB(255, 32, 73, 70),
              size: 30,
            ),
            label: "Profile",
          ),
        ],
        backgroundColor: const Color(0xFF183a37),
        // Color(0xFF283618),
        elevation: 3,
        animationDuration: const Duration(milliseconds: 500),
      ),
    );
  }
}
