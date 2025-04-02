import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:news_portal/controllers/auth_controller.dart';

class ArticleController extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  final TextEditingController summaryController = TextEditingController();
  final AuthController authController = Get.put(AuthController());

  final String apiUrl = "http://localhost:8080/api/articles";

  Future<void> postArticle() async {
    final Map<String, dynamic> articleData = {
      "title": titleController.text,
      "content": contentController.text,
      "author": "John Doe",
      "category": "Technology",
      "tags": ["javascript", "nodejs", "testing"],
      "imageUrl": imageUrlController.text,
      "summary": summaryController.text,
      "status": "published",
      "publishDate": "2024-03-19T10:00:00Z"
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${authController.getToken()}",
        },
        body: jsonEncode(articleData),
      );
      print(authController.getToken());
      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        Get.snackbar("Success", "Article Posted: ${responseData['msg']}");
        print("Response: $responseData");
      } else {
        print("Error: ${response.body}");
        Get.snackbar("Error", "Failed to post article: ${response.body}");
      }
    } catch (error) {
      print("Exception: $error");
      Get.snackbar("Error", "Something went wrong");
    }
  }
}
