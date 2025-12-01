import 'package:blog_app_flutter/pages/main_page.dart';
import 'package:blog_app_flutter/providers/blog_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart'; // Import Firebase options

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with options
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BlogProvider(), lazy: false),
      ],
      child: MaterialApp(
        home: ChangeNotifierProvider(
          create: (context) => BlogProvider(),
          child: MainPage(),
        ),
      ),
    );
  }
}
