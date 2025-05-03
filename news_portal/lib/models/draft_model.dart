class DraftArticle {
  final String id;
  final String title;
  final String content;
  final String category;
  final String avatar;
  final List<String> keywords;
  final String status;
  final String createdAt;
  final String authorName;

  DraftArticle({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.avatar,
    required this.keywords,
    required this.status,
    required this.createdAt,
    required this.authorName,
  });

  factory DraftArticle.fromJson(Map<String, dynamic> json) {
    return DraftArticle(
      id: json['_id'],
      title: json['title'],
      content: json['content'],
      category: json['category'],
      avatar: json['avatar'],
      keywords: List<String>.from(json['keywords']),
      status: json['status'],
      createdAt: json['createdAt'],
      authorName: json['author']['name'],
    );
  }
}
