import 'package:blog_app_flutter/model/blog_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class BlogProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<BlogModel> _blogs = [];
  List<BlogModel> get blogs => _blogs;

  // Fetch blogs from firestore
  Future<void> fetchBlogs() async {
    try {
      final snapshot = await _firestore.collection("blogs").get();
      _blogs = snapshot.docs.map((doc) {
        final data = doc.data();
        return BlogModel(
          id: doc.id,
          title: data["title"],
          subtitle: data["subtitle"],
          authorName: data["authorName"],
          blogContent: data["blogContent"],
        );
      }).toList();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print("Error fetching blogs :$e");
    }
  }

  // Add a new blog to firestore
  Future<void> addBlog(BlogModel blog) async {
    try {
      final docRef = await _firestore.collection("blogs").add({
        "title": blog.title,
        "subtitle": blog.subtitle,
        "authorName": blog.authorName,
        "createdAt": FieldValue.serverTimestamp(),
      });

      final newBlog = blog.copyWith(id: docRef.id);
      _blogs.add(newBlog);
      notifyListeners();
    } catch (e) {
      // Handle FirebaseException specifically
      if (e is FirebaseException) {
        print("Firestore error: ${e.code} - ${e.message}");
      } else {
        print("Unexpected error: $e");
      }
    }
  }

  // Listen for real time updates(Optional)
  void listenToBlogs() {
    try {
      _firestore.collection("blogs").snapshots().listen((snapshot) {
        _blogs = snapshot.docs.map((doc) {
          // ✅ UPDATE _blogs
          final data = doc.data();
          return BlogModel(
            id: doc.id,
            title: data["title"] ?? "",
            subtitle: data["subtitle"] ?? "",
            authorName: data["authorName"] ?? "",
            blogContent: data["blogContent"] ?? "",
          );
        }).toList();
        notifyListeners();
      });
    } catch (e) {
      if (kDebugMode) print("Error listening to blogs: $e");
    }
    // ✅ NO RETURN STATEMENT
  }

  // void uploadBlog(BlogModel blog) {
  //   // use firebase firestore to upload the data
  // }
}
