import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/draft_model.dart';
import 'auth_controller.dart';

class DraftController extends GetxController {
  var isLoading = false.obs;
  var draftArticles = <DraftArticle>[].obs;

  final String baseUrl = "http://localhost:8080/api/articles/editor/drafts";

  late final AuthController _authController;

  @override
  void onInit() {
    super.onInit();
    _authController = Get.put(AuthController());
    fetchDraftArticles();
  }

  Future<void> fetchDraftArticles() async {
    try {
      isLoading(true);
      final token = _authController.getToken();
      if (token == null || token.isEmpty) {
        Get.snackbar("Authentication", "Token not found. Please login again.");
        return;
      }

      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List jsonData = json.decode(response.body);
        draftArticles.value = jsonData.map((json) => DraftArticle.fromJson(json)).toList();
      } else {
        Get.snackbar("Error", "Failed to load drafts (Status: ${response.statusCode})");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading(false);
    }
  }

  void approveArticle(String id) {
    draftArticles.removeWhere((article) => article.id == id);
    Get.snackbar("Success", "Article approved");
    // TODO: Implement backend approve logic here
  }

  void rejectArticle(String id) {
    draftArticles.removeWhere((article) => article.id == id);
    Get.snackbar("Rejected", "Article rejected");
    // TODO: Implement backend reject logic here
  }
}
