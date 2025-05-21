import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:news_portal/core/api_constants.dart';
import 'package:news_portal/editor/editor_page.dart';
import 'package:news_portal/pages/auth/login_page.dart';

import '../author/author.dart';

class AuthController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;
  var rememberMe = false.obs;
  var obscurePassword = true.obs;
  var emailError = RxnString();

  final box = GetStorage();

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
        Uri.parse(loginUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Save token
        box.write("token", responseData["token"]);

        // Save user details
        box.write("user_id", responseData["user"]["id"]);
        box.write("user_name", responseData["user"]["name"]);
        box.write("user_email", responseData["user"]["email"]);
        box.write("user_role", responseData["user"]["role"]);

        // For backward compatibility with existing code
        box.write("user", responseData["user"]["role"]);
        box.write("isLoggedIn", true);

        Get.snackbar("Success", "Logged in successfully",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);

        // Navigate based on role
        checkUserScope(responseData["user"]["role"]);
        print(responseData["user"]["role"]);
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
    Get.to(LoginPage());
  }

  void checkLoginStatus() {
    bool isLoggedIn = box.read("isLoggedIn") ?? false;
    if (isLoggedIn && getToken() != null) {
      Future.delayed(Duration.zero, () {
        Get.offAll(() => const AuthorNewsPage());
      });
    }
  }

  void checkUserScope(String role) {
    switch (role) {
      case "editor":
        {
          Get.to(DraftArticlesScreen());
          print("editor role ");
          break;
        }
      case "author":
        {
          Get.to(AuthorNewsPage());
          print("author role ");
          break;
        }
      default:
        {
          print("Unknown role: $role");
          break;
        }
    }
  }

  String? getToken() {
    return box.read("token");
  }

  // Updated method to get complete user information
  Map<String, dynamic> getUserInfo() {
    return {
      "id": box.read("user_id"),
      "name": box.read("user_name"),
      "email": box.read("user_email"),
      "role": box.read("user_role"),
    };
  }

  // For backward compatibility
  Map<String, dynamic>? getUser() {
    return box.read("user");
  }

  // Individual getters for user information
  String? getUserId() {
    return box.read("user_id");
  }

  String? getUserName() {
    return box.read("user_name");
  }

  String? getUserEmail() {
    return box.read("user_email");
  }

  String? getUserRole() {
    return box.read("user_role");
  }
}
