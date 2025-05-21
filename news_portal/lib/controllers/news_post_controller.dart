import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:news_portal/controllers/auth_controller.dart';
import 'package:news_portal/core/api_constants.dart';

class ArticleController extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController keywordsController = TextEditingController();

  final AuthController authController = Get.put(AuthController());


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
      var request = http.MultipartRequest('POST', Uri.parse(articleUrl));

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
