import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:news_portal/controllers/auth_provider.dart';

/*
{
  "title": "Test Article Title",
  "content": "This is a test article content with multiple paragraphs.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
  "author": "John Doe",
  "category": "Technology",
  "tags": ["javascript", "nodejs", "testing"],
  "imageUrl": "https://example.com/image.jpg",
  "summary": "A brief summary of the test article",
  "status": "published",
  "publishDate": "2024-03-19T10:00:00Z"
}
*/
class NewsPostController extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  final TextEditingController summaryController = TextEditingController();
  final AuthController authController = Get.put(AuthController());

  final String postNewsUrl = "http://localhost:8080/api/articles";
  Future<void> postNews() async {
    // try {
    print("token is :${authController.getToken()}");
    var response = await http.post(
      Uri.parse(postNewsUrl),
      headers: {
        "Authorization": "Bearer ${authController.getToken()}",
        "ContentType": "Application/json",
      },
      body: jsonEncode({
        {
          "title": "Test Article Title",
          "content":
              "This is a test article content with multiple paragraphs.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
          "author": "John Doe",
          "category": "Technology",
          "tags": ["javascript", "nodejs", "testing"],
          "imageUrl": "https://example.com/image.jpg",
          "summary": "A brief summary of the test article",
          "status": "published",
          "publishDate": "2024-03-19T10:00:00Z"
        }
      }),
    );
    var postNewsResponse = jsonDecode(response.body);
    print(postNewsResponse);
    if (response.statusCode == 201) {
      print("news posted successfully");
      Get.snackbar("Success", "News ddddddPosted Successfully");
      Get.back();
    }
    // } catch (e) {
    //   Get.snackbar('Error', "error occured while posting news");
    // } finally {}
  }
}
// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;

// class ArticleController extends GetxController {
//   final String apiUrl = "http://localhost:8080/api/articles";
//   final String authToken =
//       "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2N2RhZmQ1ZmU5Mzc2NTA0OTg3NjMxZTAiLCJyb2xlIjoiYXV0aG9yIiwiaWF0IjoxNzQzNTAzMDgzLCJleHAiOjE3NDM1ODk0ODN9.WGspyP9vjKuKEYH5IC9khfXDlSZUeFeXu0rd5-6OCRU"; // Replace with your actual token

//   Future<void> postArticle() async {
//     final Map<String, dynamic> articleData = {
//       "title": "Test Article Title",
//       "content":
//           "This is a test article content with multiple paragraphs.\n\nLorem ipsum dolor sit amet...",
//       "author": "John Doe",
//       "category": "Technology",
//       "tags": ["javascript", "nodejs", "testing"],
//       "imageUrl": "https://example.com/image.jpg",
//       "summary": "A brief summary of the test article",
//       "status": "published",
//       "publishDate": "2024-03-19T10:00:00Z"
//     };

//     try {
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $authToken",
//         },
//         body: jsonEncode(articleData),
//       );

//       if (response.statusCode == 201 || response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         Get.snackbar("Success", "Article Posted: ${responseData['msg']}");
//         print("Response: $responseData");
//       } else {
//         print("Error: ${response.body}");
//         Get.snackbar("Error", "Failed to post article: ${response.body}");
//       }
//     } catch (error) {
//       print("Exception: $error");
//       Get.snackbar("Error", "Something went wrong");
//     }
//   }
// }
