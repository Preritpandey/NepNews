import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/get_article_controller.dart';
import '../pages/Home/atricle_search_page.dart';

class ArticleSearchWidget extends StatelessWidget {
  final GetArticleController articleController =
      Get.find<GetArticleController>();

  ArticleSearchWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the search screen when tapped
        Get.to(() => ArticleSearchScreen());
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
      ),
    );
  }
}
