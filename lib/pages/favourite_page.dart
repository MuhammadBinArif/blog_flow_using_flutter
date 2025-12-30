import 'package:blog_app_flutter/providers/blog_provider.dart';
import 'package:blog_app_flutter/widgets/my_blog_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavouritePage extends StatelessWidget {
  const FavouritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final blogProvider = Provider.of<BlogProvider>(context);

    // Get grouped blogs
    final groupedBlogs = blogProvider.getBlogsGroupedByAuthor();

    return Scaffold(
      backgroundColor: Color(0xFF90a955),
      appBar: AppBar(
        title: Text("Favourite Authors"),
        backgroundColor: Color(0xFF283618),
      ),
      body: ListView.builder(
        itemCount: groupedBlogs.length,
        itemBuilder: (context, index) {
          // Get the authorId at this index
          final authorId = groupedBlogs.keys.elementAt(index);
          final blogsByAuthor = groupedBlogs[authorId]!;

          // Get the first blog to display author info
          final firstBlog = blogsByAuthor.first;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Author: ${firstBlog.authorName}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: blogsByAuthor.length,
                itemBuilder: (context, blogIndex) {
                  final blog = blogsByAuthor[blogIndex];
                  return MyBlogCard(blog: blog);
                },
              ),
              Divider(height: 40, thickness: 2, color: Colors.grey[300]),
            ],
          );
        },
      ),
    );
  }
}
