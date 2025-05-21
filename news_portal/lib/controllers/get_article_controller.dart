import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import '../core/api_constants.dart';
import '../models/article_model.dart';

class GetArticleController extends GetxController {
  // Observable list of articles
  final RxList<ArticleModel> articles = <ArticleModel>[].obs;

  // Search results
  final RxList<ArticleModel> searchResults = <ArticleModel>[].obs;

  // Bookmarked articles
  final RxList<String> bookmarkedArticleIds = <String>[].obs;
  final RxList<ArticleModel> bookmarkedArticles = <ArticleModel>[].obs;

  // Search query
  final RxString searchQuery = ''.obs;

  // Loading state
  final RxBool isLoading = false.obs;

  // Search loading state
  final RxBool isSearching = false.obs;

  // Bookmarks loading state
  final RxBool isLoadingBookmarks = false.obs;

  // Error state
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // Offline state
  final RxBool isOffline = false.obs;

  // Storage reference
  final GetStorage _storage = GetStorage();
  final String _bookmarksKey = 'bookmarked_articles';
  final String _articlesCacheKey = 'cached_articles';
  final String _lastFetchTimeKey = 'last_fetch_time';

  @override
  void onInit() {
    super.onInit();
    loadCachedArticles();
    fetchArticles();

    // Load bookmarked articles from local storage
    loadBookmarkedArticles();

    // Debounce search to prevent too many filter operations while typing
    debounce(
      searchQuery,
      (_) => performSearch(),
      time: const Duration(milliseconds: 500),
    );
  }

  // Load cached articles from storage
  void loadCachedArticles() {
    try {
      final dynamic cachedData = _storage.read(_articlesCacheKey);
      if (cachedData != null) {
        if (cachedData is String) {
          final List<dynamic> articlesJson = json.decode(cachedData);
          final List<ArticleModel> cachedArticles = articlesJson
              .map((articleJson) => ArticleModel.fromJson(articleJson))
              .toList();
          articles.value = cachedArticles;
        } else if (cachedData is List) {
          final List<ArticleModel> cachedArticles = cachedData
              .map((articleJson) => ArticleModel.fromJson(articleJson))
              .toList();
          articles.value = cachedArticles;
        }
      }
    } catch (e) {
      print('Error loading cached articles: $e');
    }
  }

  // Save articles to local storage
  void _saveArticlesToCache(List<ArticleModel> articlesToCache) {
    try {
      final String articlesJson = json
          .encode(articlesToCache.map((article) => article.toJson()).toList());
      _storage.write(_articlesCacheKey, articlesJson);
      _storage.write(_lastFetchTimeKey, DateTime.now().toIso8601String());
    } catch (e) {
      print('Error saving articles to cache: $e');
    }
  }

  // Check if cache is stale (older than 1 hour)
  bool _isCacheStale() {
    try {
      final String? lastFetchTime = _storage.read<String>(_lastFetchTimeKey);
      if (lastFetchTime == null) return true;

      final DateTime lastFetch = DateTime.parse(lastFetchTime);
      final DateTime now = DateTime.now();
      return now.difference(lastFetch).inHours >= 1;
    } catch (e) {
      return true;
    }
  }

  // Load bookmarked article IDs from storage
  void loadBookmarkedArticles() {
    try {
      final List<dynamic>? savedIds =
          _storage.read<List<dynamic>>(_bookmarksKey);
      if (savedIds != null) {
        bookmarkedArticleIds.value =
            savedIds.map((id) => id.toString()).toList();
        updateBookmarkedArticlesList();
      }
    } catch (e) {
      print('Error loading bookmarked articles: $e');
    }
  }

  // Save bookmarked article IDs to storage
  void _saveBookmarkedArticlesToStorage() {
    try {
      _storage.write(_bookmarksKey, bookmarkedArticleIds.toList());
    } catch (e) {
      print('Error saving bookmarked articles: $e');
    }
  }

  // Toggle bookmark status for an article
  void toggleBookmark(String articleId) {
    if (isArticleBookmarked(articleId)) {
      bookmarkedArticleIds.remove(articleId);
    } else {
      bookmarkedArticleIds.add(articleId);
    }

    // Update bookmarked articles list
    updateBookmarkedArticlesList();

    // Save to storage
    _saveBookmarkedArticlesToStorage();
  }

  // Check if an article is bookmarked
  bool isArticleBookmarked(String articleId) {
    return bookmarkedArticleIds.contains(articleId);
  }

  // Update the list of bookmarked articles
  void updateBookmarkedArticlesList() {
    isLoadingBookmarks(true);

    try {
      final List<ArticleModel> bookmarked = [];

      for (final id in bookmarkedArticleIds) {
        final article = getArticleById(id);
        if (article != null) {
          bookmarked.add(article);
        }
      }

      bookmarkedArticles.value = bookmarked;
    } catch (e) {
      print('Error updating bookmarked articles list: $e');
    } finally {
      isLoadingBookmarks(false);
    }
  }

  // Fetch articles from API
  Future<void> fetchArticles() async {
    try {
      isLoading(true);
      hasError(false);
      errorMessage('');
      isOffline(false);

      // If we have cached data and it's not stale, use it
      if (articles.isNotEmpty && !_isCacheStale()) {
        isLoading(false);
        return;
      }

      final response = await http.get(Uri.parse(articleUrl));

      if (response.statusCode == 200) {
        final List<dynamic> articlesJson = json.decode(response.body);

        // Map JSON to ArticleModel objects
        final List<ArticleModel> fetchedArticles = articlesJson
            .map((articleJson) => ArticleModel.fromJson(articleJson))
            .toList();

        // Update the observable list
        articles.value = fetchedArticles;

        // Cache the articles
        _saveArticlesToCache(fetchedArticles);

        // Update bookmarked articles list with the newly fetched data
        updateBookmarkedArticlesList();
      } else {
        hasError(true);
        errorMessage('Failed to load articles: ${response.statusCode}');
      }
    } catch (e) {
      // If there's an error and we have cached data, use it
      if (articles.isNotEmpty) {
        isOffline(true);
        errorMessage('Using cached data: No internet connection');
      } else {
        hasError(true);
        errorMessage('An error occurred: $e');
      }
    } finally {
      isLoading(false);
    }
  }

  // Perform local search based on article title
  void performSearch() {
    isSearching(true);

    final query = searchQuery.value.toLowerCase().trim();

    // If query is empty, clear search results
    if (query.isEmpty) {
      searchResults.clear();
      isSearching(false);
      return;
    }

    // Filter articles by title containing the search query
    final results = articles.where((article) {
      return article.title?.toLowerCase().contains(query) ?? false;
    }).toList();

    searchResults.value = results;
    isSearching(false);
  }

  // Clear search and results
  void clearSearch() {
    searchQuery.value = '';
    searchResults.clear();
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
