import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../author/author.dart';

class AuthController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final PageController pageController = Get.put(PageController());

  var isLoading = false.obs;
  var rememberMe = false.obs;
  final box = GetStorage();

  final String apiUrl = "http://localhost:8080/api/auth/login";

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

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
        // Save login details
        box.write("token", responseData["token"]);
        box.write("user", responseData["user"]["role"]);
        print("uswere is the name ${responseData["user"]}");
        box.write("isLoggedIn", true);

        Get.snackbar("Success", "Logged in successfully",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
        Get.offAll(() => const AuthorNewsPage()); // Replace stack
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
      // Navigate to home if token and user exist
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
