class ArticleModel {
  final String id;
  final String title;
  final String content;
  final String category;
  final String avatar;
  final String cloudinaryId;
  final List<String> keywords;
  final String status;
  final Author author;
  final String createdAt;
  final String updatedAt;
  final int v;
  final Editor? editor;
  final String? publishDate;

  ArticleModel({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.avatar,
    required this.cloudinaryId,
    required this.keywords,
    required this.status,
    required this.author,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    this.editor,
    this.publishDate,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      category: json['category'] ?? '',
      avatar: json['avatar'] ?? '',
      cloudinaryId: json['cloudinary_id'] ?? '',
      keywords: List<String>.from(json['keywords'] ?? []),
      status: json['status'] ?? '',
      author: Author.fromJson(json['author'] ?? {}),
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      v: json['__v'] ?? 0,
      editor: json['editor'] != null ? Editor.fromJson(json['editor']) : null,
      publishDate: json['publishDate'],
    );
  }
}

class Author {
  final String id;
  final String name;

  Author({
    required this.id,
    required this.name,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class Editor {
  final String id;
  final String name;

  Editor({
    required this.id,
    required this.name,
  });

  factory Editor.fromJson(Map<String, dynamic> json) {
    return Editor(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}
