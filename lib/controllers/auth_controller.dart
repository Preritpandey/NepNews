import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../author/author.dart';

class AuthController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;
  var rememberMe = false.obs;
  var obscurePassword = true.obs;
  var emailError = RxnString();

  final box = GetStorage();
  final String apiUrl = "http://localhost:8080/api/auth/login";

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  void validateAndLogin() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Email regex validation
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!emailRegex.hasMatch(email)) {
      emailError.value = "Invalid email format";
      return;
    } else {
      emailError.value = null;
    }

    if (password.isEmpty) {
      Get.snackbar("Error", "Password cannot be empty",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    login();
  }

  Future<void> login() async {
    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        box.write("token", responseData["token"]);
        box.write("user", responseData["user"]["role"]);
        box.write("isLoggedIn", true);

        Get.snackbar("Success", "Logged in successfully",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
        Get.offAll(() => const AuthorNewsPage());
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
    Get.offAllNamed('/login');
  }

  void checkLoginStatus() {
    bool isLoggedIn = box.read("isLoggedIn") ?? false;
    if (isLoggedIn && getToken() != null) {
      Future.delayed(Duration.zero, () {
        Get.offAll(() => const AuthorNewsPage());
      });
    }
  }

  String? getToken() {
    return box.read("token");
  }

  Map<String, dynamic>? getUser() {
    return box.read("user");
  }
}
