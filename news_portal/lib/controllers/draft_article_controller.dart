import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:news_portal/core/api_constants.dart';
import 'dart:convert';

import '../models/draft_model.dart';
import 'auth_controller.dart';

class DraftController extends GetxController {
  var isLoading = false.obs;
  var draftArticles = <DraftArticle>[].obs;

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
        Uri.parse(approveArticleUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List jsonData = json.decode(response.body);
        draftArticles.value =
            jsonData.map((json) => DraftArticle.fromJson(json)).toList();
      } else {
        Get.snackbar(
            "Error", "Failed to load drafts (Status: ${response.statusCode})");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading(false);
    }
  }

  void approveArticle(String id) async {
    String approveArticles = "$approveArticleUrl/$id";
    final token = _authController.getToken();

    try {
      final response = await http.put(
        Uri.parse(approveArticles),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        draftArticles.removeWhere((article) => article.id == id);
        Get.snackbar("Success", "Article approved");
      } else {
        Get.snackbar("Error", "Failed to approve article");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }

  void rejectArticle(String id) {
    draftArticles.removeWhere((article) => article.id == id);
    Get.snackbar("Rejected", "Article rejected");
  }
}
