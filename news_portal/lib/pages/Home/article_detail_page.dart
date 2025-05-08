import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/get_article_controller.dart';


class ArticleDetailPage extends StatelessWidget {
  final String articleId;
  final GetArticleController articleController =
      Get.find<GetArticleController>();

  ArticleDetailPage({required this.articleId});

  @override
  Widget build(BuildContext context) {
    final article = articleController.getArticleById(articleId);

    if (article == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Article Not Found'),
        ),
        body: Center(
          child: Text('The requested article could not be found.'),
        ),
      );
    }

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

    return Scaffold(
      appBar: AppBar(
        title: Text('Article Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Article image
            if (article.avatar != null && article.avatar!.isNotEmpty)
              Image.network(
                article.avatar!,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 150,
                    color: Colors.grey[300],
                    child: Center(
                      child: Icon(Icons.image_not_supported, size: 50),
                    ),
                  );
                },
              ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category and date row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (article.category != null &&
                          article.category!.isNotEmpty)
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            article.category!,
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      if (formattedDate.isNotEmpty)
                        Text(
                          'Published on $formattedDate',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Article title
                  Text(
                    article.title ?? 'Untitled Article',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Author info
                  if (article.author != null)
                    Row(
                      children: [
                        CircleAvatar(
                          child: Text(article.author!.name![0]),
                        ),
                        SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'By ${article.author!.name}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            if (article.editor != null)
                              Text(
                                'Edited by ${article.editor!.name}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  SizedBox(height: 24),

                  // Article content
                  if (article.content != null && article.content!.isNotEmpty)
                    Text(
                      article.content!,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  SizedBox(height: 24),

                  // Keywords
                  if (article.keywords != null && article.keywords!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Keywords:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: article.keywords!
                              .map((keyword) => Chip(
                                    label: Text(keyword),
                                    backgroundColor: Colors.grey[200],
                                  ))
                              .toList(),
                        ),
                      ],
                    ),

                  // Metadata
                  SizedBox(height: 32),
                  Divider(),
                  SizedBox(height: 8),
                  Text(
                    'Article ID: ${article.id}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  if (article.createdAt != null)
                    Text(
                      'Created: ${_formatDateTime(article.createdAt!)}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  if (article.updatedAt != null)
                    Text(
                      'Last updated: ${_formatDateTime(article.updatedAt!)}',
                      style: TextStyle(
                        color: Colors.grey[600],
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
