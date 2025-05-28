import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/get_article_controller.dart';

class ArticleDetailPage extends StatelessWidget {
  final String articleId;
  final GetArticleController articleController =
      Get.find<GetArticleController>();

  ArticleDetailPage({super.key, required this.articleId});

  @override
  Widget build(BuildContext context) {
    final article = articleController.getArticleById(articleId);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (article == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Article Not Found'),
        ),
        body: const Center(
          child: Text('The requested article could not be found.'),
        ),
      );
    }

    String formattedDate = '';
    if (article.publishDate != null) {
      try {
        final date = DateTime.parse(article.publishDate!);
        formattedDate = '${date.day}/${date.month}/${date.year}';
      } catch (e) {
        formattedDate = '';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Article Details'),
        actions: [
          // Bookmark action button
          Obx(() => IconButton(
                icon: Icon(
                  articleController.isArticleBookmarked(articleId)
                      ? Icons.bookmark
                      : Icons.bookmark_border,
                  color: articleController.isArticleBookmarked(articleId)
                      ? colorScheme.primary
                      : null,
                ),
                onPressed: () {
                  articleController.toggleBookmark(articleId);
                  Get.snackbar(
                    articleController.isArticleBookmarked(articleId)
                        ? 'Article Bookmarked'
                        : 'Bookmark Removed',
                    articleController.isArticleBookmarked(articleId)
                        ? 'Article has been saved to your bookmarks'
                        : 'Article has been removed from your bookmarks',
                    snackPosition: SnackPosition.BOTTOM,
                    duration: const Duration(seconds: 2),
                  );
                },
                tooltip: 'Save article',
              )),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.avatar.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12)),
                child: Image.network(
                  article.avatar,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 150,
                      color: Colors.grey[800],
                      child: const Center(
                        child: Icon(Icons.image_not_supported,
                            size: 50, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category and Date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (article.category.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            article.category,
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      if (formattedDate.isNotEmpty)
                        Text(
                          'Published on $formattedDate',
                          style: TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.6),
                            fontSize: 13,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Title
                  Text(
                    article.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Author
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: colorScheme.primary,
                        child: Text(
                          article.author.name[0].toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'By ${article.author.name}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: colorScheme.onBackground,
                            ),
                          ),
                          if (article.editor != null)
                            Text(
                              'Edited by ${article.editor!.name}',
                              style: TextStyle(
                                fontSize: 12,
                                color: colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Content
                  if (article.content.isNotEmpty)
                    Text(
                      article.content,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: colorScheme.onBackground,
                      ),
                    ),
                  const SizedBox(height: 24),

                  // Keywords
                  if (article.keywords.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Keywords:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: colorScheme.onBackground,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: article.keywords
                              .map(
                                (keyword) => Chip(
                                  label: Text(keyword),
                                  backgroundColor:
                                      theme.brightness == Brightness.dark
                                          ? Colors.grey[700]
                                          : Colors.grey[200],
                                  labelStyle: TextStyle(
                                    color: theme.brightness == Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  const SizedBox(height: 32),
                  Divider(color: colorScheme.onSurface.withOpacity(0.2)),
                  const SizedBox(height: 8),

                  // Metadata
                  Text(
                    'Article ID: ${article.id}',
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'Created: ${_formatDateTime(article.createdAt)}',
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'Last updated: ${_formatDateTime(article.updatedAt)}',
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 12,
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

  String _formatDateTime(String dateTimeStr) {
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateTimeStr;
    }
  }
}
