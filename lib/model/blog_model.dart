class BlogModel {
  final String? id;
  final String title;
  final String subtitle;
  final String authorName;
  int views;

  BlogModel({
    this.id,
    required this.title,
    required this.subtitle,
    required this.authorName,
    this.views = 100,
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

List<BlogModel> blog = [
  BlogModel(
    id: "1",
    title: "How to master your time",
    subtitle: "The secret to time management is simple: Jedi time tricks",
    authorName: "Oliver Emberton",
  ),
  BlogModel(
    id: "2",
    title:
        "The problem isn’t that life is unfair – it’s your broken idea of fairness",
    subtitle:
        "Unless you’re winning, most of life will seem hideously unfair to you",
    authorName: "Oliver Emberton",
  ),
  BlogModel(
    id: "3",
    title: "The only way to be confident",
    subtitle: "How are you supposed to be confident",
    authorName: "Mark Manson",
  ),
  BlogModel(
    id: "4",
    title: "Why procrastinators procrastinate",
    subtitle: "Avoid procrastination. So elegant in its simplicity.",
    authorName: "Tim Urban",
  ),
  BlogModel(
    id: "5",
    title: "Lifestyle design of your ideal world",
    subtitle: "How to Consciously Build the Life You Truly Want",
    authorName: "The art of non-conformity",
  ),
];
