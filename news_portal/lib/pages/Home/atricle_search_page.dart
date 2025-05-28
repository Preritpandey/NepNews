import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_portal/pages/Home/article_detail_page.dart';

import '../../controllers/get_article_controller.dart';
import '../../models/article_model.dart';

class ArticleSearchScreen extends StatelessWidget {
  final GetArticleController articleController =
      Get.put(GetArticleController());

  ArticleSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Articles'),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildSearchBox(),
          Expanded(
            child: Obx(() => _buildSearchResults()),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) => articleController.searchQuery.value = value,
        decoration: InputDecoration(
          hintText: 'Search for articles...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: Obx(() => articleController.searchQuery.value.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => articleController.clearSearch(),
                )
              : const SizedBox.shrink()),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Get.theme.colorScheme.surfaceVariant.withOpacity(0.3),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    // Show searching indicator
    if (articleController.isSearching.value) {
      return const Center(child: CircularProgressIndicator());
    }

    // Show empty search message when search query is empty
    if (articleController.searchQuery.value.isEmpty) {
      return _buildEmptySearchPrompt();
    }

    // Show no results message
    if (articleController.searchResults.isEmpty &&
        articleController.searchQuery.value.isNotEmpty) {
      return _buildNoResultsMessage();
    }

    // Show search results
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: articleController.searchResults.length,
      itemBuilder: (context, index) {
        final article = articleController.searchResults[index];
        return _buildArticleCard(context, article);
      },
    );
  }

  Widget _buildEmptySearchPrompt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 80,
            color: Get.theme.colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Start typing to search for articles',
            style: Get.textTheme.titleMedium?.copyWith(
              color: Get.theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.article_outlined,
            size: 80,
            color: Get.theme.colorScheme.error.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No articles found for "${articleController.searchQuery.value}"',
            style: Get.textTheme.titleMedium?.copyWith(
              color: Get.theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try using different keywords',
            style: Get.textTheme.bodyMedium?.copyWith(
              color: Get.theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleCard(BuildContext context, ArticleModel article) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to article detail screen
          Get.to(() => ArticleDetailPage(articleId: article.id));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Article Image
            ClipRRect(
              child: article.avatar.isNotEmpty
                  ? Image.network(
                      article.avatar,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 180,
                          width: double.infinity,
                          color: Get.theme.colorScheme.primaryContainer,
                          child: Center(
                            child: Icon(
                              Icons.image_not_supported,
                              color: Get.theme.colorScheme.onPrimaryContainer,
                              size: 36,
                            ),
                          ),
                        );
                      },
                    )
                  : Container(
                      height: 180,
                      width: double.infinity,
                      color: Get.theme.colorScheme.primaryContainer,
                      child: Center(
                        child: Icon(
                          Icons.newspaper,
                          color: Get.theme.colorScheme.onPrimaryContainer,
                          size: 36,
                        ),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Get.theme.colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      article.category,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Get.theme.colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Title
                  Text(
                    article.title,
                    style: Get.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Content preview
                  Text(
                    _stripHtmlTags(article.content),
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: Get.theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),

                  // Author and date info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: Get.theme.colorScheme.primary,
                            child: Text(
                              article.author.name.isNotEmpty
                                  ? article.author.name[0].toUpperCase()
                                  : '?',
                              style: TextStyle(
                                color: Get.theme.colorScheme.onPrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            article.author.name,
                            style: Get.textTheme.bodySmall,
                          ),
                        ],
                      ),
                      Text(
                        _formatDate(article.publishDate ?? article.createdAt),
                        style: Get.textTheme.bodySmall?.copyWith(
                          color:
                              Get.theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to strip HTML tags from content
  String _stripHtmlTags(String htmlString) {
    final RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '');
  }

  // Helper function to format date
  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
