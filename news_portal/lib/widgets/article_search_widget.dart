import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/get_article_controller.dart';

class ArticleSearchWidget extends StatelessWidget {
  final GetArticleController articleController =
      Get.find<GetArticleController>();

  ArticleSearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Get.theme.colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: Get.theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
          ),
          const SizedBox(width: 12),
          Text(
            'Search for articles...',
            style: TextStyle(
              color: Get.theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
