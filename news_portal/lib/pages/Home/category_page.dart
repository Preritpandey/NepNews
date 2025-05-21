import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_portal/pages/Home/article_detail_page.dart';
import 'package:news_portal/pages/Home/home.dart';

import '../../controllers/get_article_controller.dart';
import '../../models/article_model.dart';

class CategoryController extends GetxController {
  final RxString selectedCategory = 'All'.obs;

  void changeCategory(String category) {
    selectedCategory.value = category;
  }
}

class CategoryPage extends StatelessWidget {
  final CategoryController categoryController = Get.put(CategoryController());
  final GetArticleController articleController =
      Get.put(GetArticleController());

  CategoryPage({super.key});

  // Get unique categories from articles
  List<String> getCategories() {
    final Set<String> uniqueCategories = {'All'};
    for (var article in articleController.articles) {
      if (article.category.isNotEmpty) {
        uniqueCategories.add(article.category!);
      }
    }
    return uniqueCategories.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () => Get.to(const Home()),
            icon: Icon(Icons.arrow_back_ios)),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => articleController.refreshArticles(),
          ),
        ],
      ),
      body: Obx(() {
        if (articleController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (articleController.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Error loading articles',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(articleController.errorMessage.value),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => articleController.refreshArticles(),
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        }

        // Get categories based on available articles
        final categories = getCategories();

        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.backgroundColor,
              ),
              child: CategoryNavBar(
                categories: categories,
                controller: categoryController,
              ),
            ),
            Expanded(
              child: _buildCategoryContent(
                categoryController.selectedCategory.value,
                articleController,
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildCategoryContent(
      String category, GetArticleController controller) {
    // Filter articles based on selected category
    List<ArticleModel> filteredArticles = [];

    if (category == 'All') {
      filteredArticles = controller.articles;
    } else {
      filteredArticles = controller.articles
          .where((article) => article.category == category)
          .toList();
    }

    if (filteredArticles.isEmpty) {
      return const Center(
        child: Text(
          'No articles found in this category',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredArticles.length,
      itemBuilder: (context, index) {
        final article = filteredArticles[index];
        return ArticleCard(article: article);
      },
    );
  }
}

class CategoryNavBar extends StatelessWidget {
  final List<String> categories;
  final CategoryController controller;

  const CategoryNavBar({
    super.key,
    required this.categories,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Get the primary and text colors from the theme
    final primaryColor = theme.colorScheme.primary;
    final textColor =
        theme.textTheme.bodyLarge?.color ?? theme.colorScheme.onBackground;
    final isDarkMode = theme.brightness == Brightness.dark;
    final surfaceColor = theme.colorScheme.surface;

    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Obx(() {
            final category = categories[index];
            final isSelected = controller.selectedCategory.value == category;

            // Define colors based on theme and selection state
            final backgroundColor = isSelected
                ? (isDarkMode
                    ? surfaceColor
                    : theme.colorScheme.surface.withOpacity(0.9))
                : (isDarkMode ? Colors.transparent : Colors.transparent);

            final borderColor = isSelected ? primaryColor : Colors.transparent;

            final textStyle = TextStyle(
              color: isSelected ? primaryColor : textColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            );

            return GestureDetector(
              onTap: () => controller.changeCategory(category),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: backgroundColor,
                  border: isSelected
                      ? Border.all(color: primaryColor, width: 1.5)
                      : null,
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? primaryColor : textColor,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }
}

class ArticleCard extends StatelessWidget {
  final ArticleModel article;

  const ArticleCard({
    Key? key,
    required this.article,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format publish date if available
    String formattedDate = '';
    if (article.publishDate != null) {
      try {
        final date = DateTime.parse(article.publishDate!);
        formattedDate = '${date.day}/${date.month}/${date.year}';
      } catch (e) {
        formattedDate = '';
      }
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to article detail page
          Get.to(() => ArticleDetailPage(articleId: article.id));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Article image
            if (article.avatar != null && article.avatar!.isNotEmpty)
              Image.network(
                article.avatar!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 120,
                    color: Theme.of(context).colorScheme.surface,
                    child: Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 40,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.6),
                      ),
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 120,
                    color: Theme.of(context).colorScheme.surface,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  );
                },
              ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category badge
                  if (article.category != null && article.category!.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        article.category!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),

                  // Article title
                  Text(
                    article.title ?? 'Untitled Article',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Article content preview
                  if (article.content != null && article.content!.isNotEmpty)
                    Text(
                      article.content!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.titleMedium?.color,
                        fontSize: 14,
                      ),
                    ),
                  const SizedBox(height: 12),

                  // Article metadata
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Author info
                      if (article.author != null)
                        Text(
                          'By ${article.author!.name ?? 'Unknown'}',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color,
                          ),
                        ),

                      // Publish date
                      if (formattedDate.isNotEmpty)
                        Text(
                          formattedDate,
                          style: TextStyle(
                            color:
                                Theme.of(context).textTheme.titleMedium?.color,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),

                  // Keywords
                  if (article.keywords != null && article.keywords!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: article.keywords!
                            .map((keyword) => Chip(
                                  label: Text(
                                    keyword,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.surface,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  padding: EdgeInsets.zero,
                                  labelPadding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                ))
                            .toList(),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
