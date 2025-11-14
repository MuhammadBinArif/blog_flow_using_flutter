class BlogModel {
  String title;
  String subtitle;
  String authorName;
  int views;

  BlogModel({
    required this.title,
    required this.subtitle,
    required this.authorName,
    this.views = 100,
  });
}

List<BlogModel> blog = [
  BlogModel(
    title: "How to master your time",
    subtitle: "The secret to time management is simple: Jedi time tricks",
    authorName: "Oliver Emberton",
  ),
  BlogModel(
    title:
        "The problem isn’t that life is unfair – it’s your broken idea of fairness",
    subtitle:
        "Unless you’re winning, most of life will seem hideously unfair to you",
    authorName: "Oliver Emberton",
  ),
  BlogModel(
    title: "The only way to be confident",
    subtitle: "How are you supposed to be confident",
    authorName: "Mark Manson",
  ),
  BlogModel(
    title: "Why procrastinators procrastinate",
    subtitle: "Avoid procrastination. So elegant in its simplicity.",
    authorName: "Tim Urban",
  ),
  BlogModel(
    title: "Lifestyle design of your ideal world",
    subtitle: "How to Consciously Build the Life You Truly Want",
    authorName: "The art of non-conformity",
  ),
];
