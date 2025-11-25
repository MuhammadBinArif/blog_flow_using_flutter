import 'package:blog_app_flutter/pages/main_page.dart';
import 'package:blog_app_flutter/providers/blog_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<BlogProvider>(context);
//     print("PROVIDER STATUS: ${provider.blogs.length} blogs loaded");
//     final blogProvider = Provider.of<BlogProvider>(context, listen: false);
//     return SafeArea(child: Scaffold(body: MainPage()));
//   }
// }

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final blogProvider = Provider.of<BlogProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: blogProvider.blogs.isEmpty
          ? Center(child: Text("No blogs"))
          : ListView.builder(
              itemCount: blogProvider.blogs.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(blogProvider.blogs[index].title),
                leading: MainPage(),
              ),
            ),
    );
  }
}
