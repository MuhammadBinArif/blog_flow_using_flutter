import 'package:blog_app_flutter/pages/home_page.dart';
import 'package:blog_app_flutter/widgets/add_blog_container.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      home:
          // const AddBlogContainer(),
          const HomePage(),
    );
  }
}
