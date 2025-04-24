import 'dart:convert';

class AdModel {
  final String id;
  final String title;
  final String placement;
  final String avatar;
  final String cloudinaryId;
  final String url;
  final String category;
  final DateTime createdAt;
  final DateTime updatedAt;

  AdModel({
    required this.id,
    required this.title,
    required this.placement,
    required this.avatar,
    required this.cloudinaryId,
    required this.url,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(
      id: json['_id'],
      title: json['title'],
      placement: json['placement'],
      avatar: json['avatar'],
      cloudinaryId: json['cloudinary_id'],
      url: json['url'],
      category: json['category'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'placement': placement,
      'avatar': avatar,
      'cloudinary_id': cloudinaryId,
      'url': url,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  static List<AdModel> fromJsonList(String str) {
    final List<dynamic> jsonData = json.decode(str);
    return jsonData.map((item) => AdModel.fromJson(item)).toList();
  }
}
