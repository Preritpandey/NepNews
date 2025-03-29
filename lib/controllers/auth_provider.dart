import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthProvider extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  bool _rememberMe = false;

  bool get isLoading => _isLoading;
  bool get rememberMe => _rememberMe;

  final String apiUrl = "http://localhost:8080/api/auth/login";

  void toggleRememberMe() {
    _rememberMe = !_rememberMe;
    notifyListeners();
  }

  Future<void> login(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

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
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", responseData["token"]);
        await prefs.setString("user", jsonEncode(responseData["user"]));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Logged in successfully"),
              backgroundColor: Colors.green),
        );

        Navigator.pushReplacementNamed(context, "/home");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(responseData["msg"] ?? "Login failed"),
              backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Something went wrong. Try again later."),
            backgroundColor: Colors.red),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, "/login");
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  Future<Map<String, dynamic>?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString("user");
    return userData != null ? jsonDecode(userData) : null;
  }
}
