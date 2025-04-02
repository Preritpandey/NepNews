import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:news_portal/author/author.dart';

class AuthController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var isLoading = false.obs;
  var rememberMe = false.obs;
  final box = GetStorage();``

  final String apiUrl = "http://localhost:8080/api/auth/login";

  Future<void> login() async {
    isLoading.value = true;

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
        }),
      );

      var responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        box.write("token", responseData["token"]);
        box.write("user", responseData["user"]);

        Get.snackbar("Success", "Logged in successfully",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
        Get.to(AuthorNewsPage());
        // Get.offAllNamed('/home'); // Navigate to home screen
      } else {
        Get.snackbar("Error", responseData["msg"] ?? "Login failed",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong. Try again later.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    box.erase();
    Get.offAllNamed('/login'); // Navigate back to login
  }

  String? getToken() {
    return box.read("token");
  }

  Map<String, dynamic>? getUser() {
    return box.read("user");
  }
}
