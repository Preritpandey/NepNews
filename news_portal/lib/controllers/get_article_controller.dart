import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/article_model.dart';

class GetArticleController extends GetxController {
  // Observable list of articles
  final RxList<ArticleModel> articles = <ArticleModel>[].obs;

  // Loading state
  final RxBool isLoading = false.obs;

  // Error state
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // API URL
  final String apiUrl = 'http://localhost:8080/api/articles';

  @override
  void onInit() {
    super.onInit();
    fetchArticles();
  }

  // Fetch articles from API
  Future<void> fetchArticles() async {
    try {
      isLoading(true);
      hasError(false);
      errorMessage('');

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> articlesJson = json.decode(response.body);

        // Map JSON to ArticleModel objects
        final List<ArticleModel> fetchedArticles = articlesJson
            .map((articleJson) => ArticleModel.fromJson(articleJson))
            .toList();

        // Update the observable list
        articles.value = fetchedArticles;
      } else {
        hasError(true);
        errorMessage('Failed to load articles: ${response.statusCode}');
      }
    } catch (e) {
      hasError(true);
      errorMessage('An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }

  // Get breaking news (latest articles)
  List<ArticleModel> getBreakingNews() {
    // Sort by publishDate and return the most recent ones
    final sortedArticles = [...articles]..sort((a, b) {
        if (a.publishDate == null) return 1;
        if (b.publishDate == null) return -1;
        return DateTime.parse(b.publishDate!)
            .compareTo(DateTime.parse(a.publishDate!));
      });

    // Return top 5 or all if less than 5
    return sortedArticles.take(5).toList();
  }

  // Get article by ID
  ArticleModel? getArticleById(String id) {
    try {
      return articles.firstWhere((article) => article.id == id);
    } catch (_) {
      return null;
    }
  }

  // Get articles by category
  List<ArticleModel> getArticlesByCategory(String category) {
    return articles.where((article) => article.category == category).toList();
  }

  // Refresh articles data
  void refreshArticles() {
    fetchArticles();
  }
}
