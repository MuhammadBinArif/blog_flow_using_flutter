import 'package:cloud_firestore/cloud_firestore.dart';

class BlogModel {
  final String? id;
  final String title;
  final String subtitle;
  final String authorName;
  final String imagePath;
  final String blogContent;
  int views;

  BlogModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.authorName,
    required this.imagePath,
    required this.blogContent,
    this.views = 100,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "subtitle": subtitle,
      "authorName": authorName,
      "imagePath": imagePath,
      "blogContent": blogContent,
      "createdAt": FieldValue.serverTimestamp(),
    };
  }

  BlogModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? authorName,
    String? imagePath,
    String? blogContent,
    int? views,
  }) {
    return BlogModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      authorName: authorName ?? this.authorName,
      imagePath: imagePath ?? this.imagePath,
      blogContent: blogContent ?? this.blogContent,
      views: views ?? this.views,
    );
  }
}

// List<BlogModel> blog = [
//   BlogModel(
//     id: "1",
//     title: "How to master your time",
//     subtitle: "The secret to time management is simple: Jedi time tricks",
//     authorName: "Oliver Emberton",
//   ),
//   BlogModel(
//     id: "2",
//     title:
//         "The problem isn’t that life is unfair – it’s your broken idea of fairness",
//     subtitle:
//         "Unless you’re winning, most of life will seem hideously unfair to you",
//     authorName: "Oliver Emberton",
//   ),
//   BlogModel(
//     id: "3",
//     title: "The only way to be confident",
//     subtitle: "How are you supposed to be confident",
//     authorName: "Mark Manson",
//   ),
//   BlogModel(
//     id: "4",
//     title: "Why procrastinators procrastinate",
//     subtitle: "Avoid procrastination. So elegant in its simplicity.",
//     authorName: "Tim Urban",
//   ),
//   BlogModel(
//     id: "5",
//     title: "Lifestyle design of your ideal world",
//     subtitle: "How to Consciously Build the Life You Truly Want",
//     authorName: "The art of non-conformity",
//   ),
// ];
