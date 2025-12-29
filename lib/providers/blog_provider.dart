import 'dart:io';

import 'package:blog_app_flutter/model/blog_model.dart';
import 'package:blog_app_flutter/services/cloudinary_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class BlogProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<BlogModel> _blogs = [];
  List<BlogModel> get blogs => _blogs;

  // ✅ ADD THIS UPLOAD IMAGE METHOD
  Future<String> uploadImage(File imageFile) async {
    try {
      // Call CloudinaryService to upload the image
      final imageUrl = await CloudinaryService.uploadImage(imageFile);

      if (imageUrl == null) {
        throw Exception('Failed to upload image to Cloudinary');
      }

      return imageUrl; // Returns the Cloudinary URL
    } catch (e) {
      print('Error in uploadImage: $e');
      throw Exception('Image upload failed: $e');
    }
  }

  Future<void> addBlog(BlogModel blog) async {
    try {
      await _firestore.collection("blogs").doc(blog.id).set({
        "id": blog.id,
        "title": blog.title,
        "subtitle": blog.subtitle,
        "authorName": blog.authorName,
        "blogContent": blog.blogContent,
        "imagePath": blog.imagePath,
        "authorId": blog.authorId, // 👈 ADD THIS LINE
        "createdAt": FieldValue.serverTimestamp(),
      });

      _blogs.add(blog);
      notifyListeners();
    } catch (e) {
      if (e is FirebaseException) {
        print("Firestore error: ${e.code} - ${e.message}");
      } else {
        print("Unexpected error: $e");
      }
      rethrow;
    }
  }

  // ✅ NEW METHOD: Get blogs grouped by authorId
  Map<String, List<BlogModel>> getBlogsGroupedByAuthor() {
    final grouped = <String, List<BlogModel>>{};

    for (final blog in _blogs) {
      if (!grouped.containsKey(blog.authorId)) {
        grouped[blog.authorId] = [];
      }
      grouped[blog.authorId]!.add(blog);
    }

    return grouped;
  }

  // // ✅ UPDATE YOUR EXISTING addBlog METHOD
  // Future<void> addBlog(BlogModel blog) async {
  //   try {
  //     await _firestore.collection("blogs").doc(blog.id).set({
  //       "id": blog.id,
  //       "title": blog.title,
  //       "subtitle": blog.subtitle,
  //       "authorName": blog.authorName,
  //       "blogContent": blog.blogContent, // ✅ ADD THIS
  //       "imagePath": blog.imagePath, // ✅ ADD THIS
  //       "createdAt": FieldValue.serverTimestamp(),
  //     });

  //     _blogs.add(blog);
  //     notifyListeners();
  //   } catch (e) {
  //     if (e is FirebaseException) {
  //       print("Firestore error: ${e.code} - ${e.message}");
  //     } else {
  //       print("Unexpected error: $e");
  //     }
  //     rethrow; // Important for error handling in UI
  //   }
  // }

  // Fetch blogs from firestore
  Future<void> fetchBlogs() async {
    try {
      final snapshot = await _firestore.collection("blogs").get();
      _blogs = snapshot.docs.map((doc) {
        final data = doc.data();
        return BlogModel(
          id: doc.id,
          title: data["title"] as String? ?? "", // 👈 Safe cast + fallback
          subtitle: data["subtitle"] as String? ?? "",
          authorName: data["authorName"] as String? ?? "",
          blogContent: data["blogContent"] as String? ?? "",
          imagePath: data["imagePath"] as String? ?? "",
          authorId:
              data["authorId"] as String? ?? "unknown_author", // ✅ Add fallback
        );
      }).toList();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print("Error fetching blogs :$e");
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
            title: data["title"] as String? ?? "", // 👈 Cast + fallback
            subtitle: data["subtitle"] as String? ?? "",
            authorName: data["authorName"] as String? ?? "",
            blogContent: data["blogContent"] as String? ?? "",
            imagePath: data["imagePath"] as String? ?? "",
            authorId: data["authorId"] as String? ?? "", // ✅ ADD THIS LINE
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


/**
 *  // .add({
      //   "title": blog.title,
      //   "subtitle": blog.subtitle,
      //   "authorName": blog.authorName,
      //   "blogContent": blog.blogContent, // Add this
      //   "imagePath": blog.imagePath, // Add this
      //   "createdAt": FieldValue.serverTimestamp(),
      // });
 * 
 *  //   final newBlog = blog.copyWith(id: docRef.id);
    //   _blogs.add(newBlog);
    //   notifyListeners();
    // } catch (e) {
    //   // Handle FirebaseException specifically
    //   if (e is FirebaseException) {
    //     print("Firestore error: ${e.code} - ${e.message}");
    //   } else {
    //     print("Unexpected error: $e");
    //   }
    //   rethrow; // Important: rethrow to handle in UI
    // }
 */