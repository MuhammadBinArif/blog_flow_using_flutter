import 'package:blog_app_flutter/model/blog_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

      // Update local model with firestore generated Id
      final newBlog = blog.copyWith(id: docRef.id);
      _blogs.add(newBlog);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching blogs:$e");
      }
    }
  }

  // Listen for real time updates(Optional)
  void listenToBlogs() {
    _firestore.collection("blogs").snapshots().listen((snapshot) {
      _blogs = snapshot.docs.map((doc) {
        final data = doc.data();
        return BlogModel(
          id: doc.id,
          title: data["title"],
          subtitle: data["subtitle"],
          authorName: data["authorName"],
        );
      }).toList();
      notifyListeners();
    });
  }

  void uploadBlog(BlogModel blog) {
    // use firebase firestore to upload the data
  }
}

/**
 * 
 * To implement **Provider** and **Firebase Firestore** in your `AddBlogBottomSheet` so that other parts of your app are notified when a new blog is added, follow these steps:

---

### ✅ 1. **Add Dependencies**

Ensure you have the following in your `pubspec.yaml`:

```yaml
dependencies:
  provider: ^6.1.1
  cloud_firestore: ^4.9.2
```

Run:
```bash
flutter pub get
```

---

### ✅ 2. **Create a Blog Provider (`blog_provider.dart`)**

This will manage the list of blogs and sync with Firestore.

```dart
// providers/blog_provider.dart
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:blog_app_flutter/model/blog_model.dart';

class BlogProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<BlogModel> _blogs = [];

  List<BlogModel> get blogs => _blogs;

  // Fetch blogs from Firestore
  Future<void> fetchBlogs() async {
    try {
      final snapshot = await _firestore.collection('blogs').get();
      _blogs = snapshot.docs.map((doc) {
        final data = doc.data();
        return BlogModel(
          id: doc.id,
          title: data['title'],
          subtitle: data['subtitle'],
          authorName: data['authorName'],
        );
      }).toList();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print("Error fetching blogs: $e");
    }
  }

  // Add a new blog to Firestore
  Future<void> addBlog(BlogModel blog) async {
    try {
      final docRef = await _firestore.collection('blogs').add({
        'title': blog.title,
        'subtitle': blog.subtitle,
        'authorName': blog.authorName,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Update local model with Firestore-generated ID
      final newBlog = blog.copyWith(id: docRef.id);
      _blogs.add(newBlog);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print("Error adding blog: $e");
    }
  }

  // Listen for real-time updates (optional)
  void listenToBlogs() {
    _firestore.collection('blogs').snapshots().listen((snapshot) {
      _blogs = snapshot.docs.map((doc) {
        final data = doc.data();
        return BlogModel(
          id: doc.id,
          title: data['title'],
          subtitle: data['subtitle'],
          authorName: data['authorName'],
        );
      }).toList();
      notifyListeners();
    });
  }
}
```

Update your `BlogModel` to support `copyWith`:

```dart
// model/blog_model.dart
class BlogModel {
  final String? id;
  final String title;
  final String subtitle;
  final String authorName;

  BlogModel({
    this.id,
    required this.title,
    required this.subtitle,
    required this.authorName,
  });

  BlogModel copyWith({String? id}) {
    return BlogModel(
      id: id ?? this.id,
      title: title,
      subtitle: subtitle,
      authorName: authorName,
    );
  }
}
```

---

### ✅ 3. **Update Your `main.dart` to Use Provider**

Wrap your app with `ChangeNotifierProvider`.

```dart
// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/blog_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => BlogProvider()..fetchBlogs(), // Fetch on startup
      child: const MyApp(),
    ),
  );
}
```

---

### ✅ 4. **Update `AddBlogBottomSheet` to Use Provider & Firestore**

Replace the `_addToBlogList()` method to use the provider instead of `blog.add()`.

```dart
void _addToBlogList() async {
  if (_formKey.currentState!.validate()) {
    final provider = Provider.of<BlogProvider>(context, listen: false);

    BlogModel newBlog = BlogModel(
      title: _titleController.text,
      subtitle: _subtitleController.text,
      authorName: _authorNameController.text,
    );

    await provider.addBlog(newBlog); // Adds to Firestore and notifies

    Navigator.of(context).pop(); // Close bottom sheet
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Color(0xFF606c38),
        content: Text(
          "Blog added successfully!",
          style: TextStyle(color: Color(0xFFecf39e)),
        ),
      ),
    );
  }
}
```

> 🔥 Note: Make sure you're calling this inside a widget tree wrapped by `Provider`.

---

### ✅ 5. **Optional: Auto-sync with Realtime Updates**

In your blog listing screen, initialize listening:

```dart
final provider = Provider.of<BlogProvider>(context, listen: false);
provider.listenToBlogs(); // Enables real-time updates
```

Or just call `fetchBlogs()` when needed.

---

### ✅ Summary

- ✅ You replaced direct list mutation (`blog.add`) with Firestore via `BlogProvider`.
- ✅ Used `Provider` to notify widgets when data changes.
- ✅ Added error handling and real-time sync capability.
- ✅ Kept form validation intact.

Now, whenever a blog is added:
- It’s saved in **Firestore**
- The **provider updates**
- All listening widgets **automatically rebuild**

Let me know if you want to add image uploads or user authentication!
 * 
 */
