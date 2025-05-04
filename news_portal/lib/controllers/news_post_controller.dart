// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:news_portal/controllers/auth_controller.dart';

// class ArticleController extends GetxController {
//   final TextEditingController titleController = TextEditingController();
//   final TextEditingController contentController = TextEditingController();
//   final TextEditingController imageUrlController = TextEditingController();
//   final TextEditingController summaryController = TextEditingController();
//   final AuthController authController = Get.put(AuthController());

//   final String apiUrl = "http://192.168.1.85:8080/api/articles";

//   Future<void> postArticle() async {
//     final Map<String, dynamic> articleData = {
//       "title": titleController.text,
//       "content": contentController.text,
//       "author": "John Doe",
//       "category": "Technology",
//       "tags": ["javascript", "nodejs", "testing"],
//       "imageUrl": imageUrlController.text,
//       "summary": summaryController.text,
//       "status": "published",
//       "publishDate": "2024-03-19T10:00:00Z"
//     };

//     try {
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer ${authController.getToken()}",
//         },
//         body: jsonEncode(articleData),
//       );
//       print(authController.getToken());
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
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:news_portal/controllers/auth_controller.dart';

class ArticleController extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController keywordsController = TextEditingController();

  final AuthController authController = Get.put(AuthController());

  final String apiUrl = "http://localhost:8080/api/articles";

  Rx<File?> selectedImage = Rx<File?>(null);
  RxBool isLoading = false.obs;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  Future<void> postArticle() async {
    if (titleController.text.isEmpty ||
        contentController.text.isEmpty ||
        categoryController.text.isEmpty ||
        selectedImage.value == null) {
      Get.snackbar(
          "Error", "Please fill all required fields and select an image");
      return;
    }

    isLoading.value = true;

    try {
      // Create multipart request
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Add auth header
      request.headers.addAll({
        "Authorization": "Bearer ${authController.getToken()}",
      });

      // Add text fields
      request.fields['title'] = titleController.text;
      request.fields['content'] = contentController.text;
      request.fields['category'] = categoryController.text;
      request.fields['keywords'] = keywordsController.text;

      // Add image file
      if (selectedImage.value != null) {
        var imageFile = await http.MultipartFile.fromPath(
          'image',
          selectedImage.value!.path,
        );
        request.files.add(imageFile);
      }

      // Send the request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        Get.snackbar("Success", "Article Posted Successfully");
        print("Response: $responseData");

        // Clear controllers
        clearControllers();
      } else {
        print("Error: ${response.body}");
        Get.snackbar("Error", "Failed to post article: ${response.statusCode}");
      }
    } catch (error) {
      print("Exception: $error");
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  void clearControllers() {
    titleController.clear();
    contentController.clear();
    categoryController.clear();
    keywordsController.clear();
    selectedImage.value = null;
  }
}
