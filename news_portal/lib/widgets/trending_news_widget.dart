import 'package:flutter/material.dart';
import 'package:news_portal/core/ScreenSizeConfig.dart';
import 'package:news_portal/pages/Home/article_detail_page.dart';
import 'package:news_portal/resources/app_text.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';

import '../controllers/ads_controller.dart';
import '../controllers/get_article_controller.dart';
import '../models/ads_data_model.dart';
import '../models/article_model.dart';

class TrendingNewsCard extends StatelessWidget {
  // Get AdController instance
  final adController = Get.find<AdController>();
  // Get ArticleController instance
  final GetArticleController articleController =
      Get.find<GetArticleController>();

  TrendingNewsCard({super.key});

  // Get random articles for trending section
  List<ArticleModel> getRandomArticles(int count) {
    final allArticles = articleController.articles;

    // If we have fewer articles than requested, return all of them
    if (allArticles.length <= count) {
      return List.from(allArticles);
    }

    // Create a copy of the articles list to shuffle
    final shuffledArticles = List<ArticleModel>.from(allArticles);

    // Shuffle the list to randomize the order
    final random = Random();
    for (int i = shuffledArticles.length - 1; i > 0; i--) {
      int j = random.nextInt(i + 1);
      // Swap elements
      final temp = shuffledArticles[i];
      shuffledArticles[i] = shuffledArticles[j];
      shuffledArticles[j] = temp;
    }

    // Return the first 'count' articles
    return shuffledArticles.take(count).toList();
  }

  // Format date string for display
  String formatDate(String? dateString) {
    if (dateString == null) return "";

    try {
      final date = DateTime.parse(dateString);
      // Format as "MMM dd, yyyy"
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return "${months[date.month - 1]} ${date.day}, ${date.year}";
    } catch (e) {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = ScreenSizeConfig.of(context);
    double screenHeight = screenSize.height;
    double screenWidth = screenSize.width;

    return Container(
      color: theme.colorScheme.background,
      child: Obx(() {
        // Check if articles are still loading
        if (articleController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Check if there's an error
        if (articleController.hasError.value) {
          return Center(
            child: Text(
                'Error loading trending news: ${articleController.errorMessage.value}'),
          );
        }

        // Get random articles for trending
        final trendingArticles = getRandomArticles(5);

        // If no articles, show a message
        if (trendingArticles.isEmpty) {
          return const Center(
            child: Text('No trending articles available'),
          );
        }

        // Get all ads
        final allAds = adController.ads;

        // If no ads available, just show news items
        if (allAds.isEmpty) {
          return ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: trendingArticles.length,
            separatorBuilder: (context, index) {
              return Divider(
                color: theme.colorScheme.onSurface.withOpacity(0.1),
                height: 1,
                thickness: 1,
                indent: screenWidth * 0.03,
                endIndent: screenWidth * 0.03,
              );
            },
            itemBuilder: (context, index) {
              return _buildNewsCard(context, trendingArticles[index],
                  screenWidth, screenHeight, theme);
            },
          );
        }

        // Calculate total items (news + ads)
        // We'll add an ad after every 2 news items
        int totalNewsItems = trendingArticles.length;
        int totalAdsToShow = (totalNewsItems / 2).floor();
        int totalItems = totalNewsItems + totalAdsToShow;

        return ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: totalItems,
          separatorBuilder: (context, index) {
            return Divider(
              color: theme.colorScheme.onSurface.withOpacity(0.1),
              height: 1,
              thickness: 1,
              indent: screenWidth * 0.03,
              endIndent: screenWidth * 0.03,
            );
          },
          itemBuilder: (context, index) {
            // Check if this position should be an ad
            // Ad positions will be after every 2 news items (at positions 2, 5, 8, etc.)
            bool isAdPosition = index > 0 && (index + 1) % 3 == 0;

            if (isAdPosition) {
              // Calculate which ad to show - we'll cycle through available ads
              int adIndex = ((index + 1) ~/ 3 - 1) % allAds.length;

              // Show ad
              final ad = allAds[adIndex];
              return _buildAdCard(
                  context, ad, screenWidth, screenHeight, theme);
            } else {
              // Calculate which news item to show
              int newsIndex;
              if (index < 3) {
                newsIndex = index;
              } else {
                newsIndex = index - ((index + 1) ~/ 3);
              }

              // Check if newsIndex is within bounds
              if (newsIndex >= trendingArticles.length) {
                return const SizedBox();
              }

              // Show news
              final article = trendingArticles[newsIndex];
              return _buildNewsCard(
                  context, article, screenWidth, screenHeight, theme);
            }
          },
        );
      }),
    );
  }

  // Building news card widget using ArticleModel
  Widget _buildNewsCard(BuildContext context, ArticleModel article,
      double screenWidth, double screenHeight, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.only(
          right: screenWidth * 0.03,
          left: screenWidth * 0.03,
          top: screenHeight * 0.015,
          bottom: screenHeight * 0.015),
      child: InkWell(
        onTap: () {
          // Navigate to article detail page
          Get.to(() => ArticleDetailPage(articleId: article.id));
                },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // News Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: article.avatar.isNotEmpty
                  ? Image.network(
                      article.avatar,
                      width: screenWidth * 0.3,
                      height: screenHeight * 0.14,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: screenWidth * 0.3,
                          height: screenHeight * 0.14,
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          child: const Icon(Icons.image_not_supported),
                        );
                      },
                    )
                  : Container(
                      width: screenWidth * 0.3,
                      height: screenHeight * 0.14,
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      child: const Icon(Icons.image_not_supported),
                    ),
            ),
            const SizedBox(width: 12),
            // News Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category
                  if (article.category.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: AppText(
                        text: article.category,
                        color: theme.colorScheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  const SizedBox(height: 8),
                  // News Title
                  AppText(
                    text: article.title,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 8),
                  // Author and Date
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundColor:
                            theme.colorScheme.primary.withOpacity(0.2),
                        // ignore: unnecessary_null_comparison
                        child: article.author.name != null
                            ? Text(
                                article.author.name[0],
                                style: TextStyle(
                                  fontSize: 10,
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : Icon(
                                Icons.person,
                                size: 12,
                                color: theme.colorScheme.primary,
                              ),
                      ),
                      const SizedBox(width: 6),
                      AppText(
                        text: article.author.name,
                        fontSize: 11,
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "•",
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(width: 8),
                      AppText(
                        text: formatDate(article.publishDate),
                        fontSize: 11,
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
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

  // Building ad card widget
  Widget _buildAdCard(BuildContext context, AdModel ad, double screenWidth,
      double screenHeight, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.only(
          right: screenWidth * 0.03,
          left: screenWidth * 0.03,
          top: screenHeight * 0.015,
          bottom: screenHeight * 0.015),
      child: Column(
        children: [
          // Ad Label
          const Row(
            children: [],
          ),
          const SizedBox(height: 8),
          // Ad Content
          InkWell(
            onTap: () {
              launchUrl(Uri.parse(ad.url));
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ad Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    ad.avatar,
                    width: screenWidth * 0.3,
                    height: screenHeight * 0.14,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: screenWidth * 0.3,
                        height: screenHeight * 0.14,
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        child: const Icon(Icons.image_not_supported),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                // Ad Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Ad category
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: AppText(
                          text: ad.category,
                          color: theme.colorScheme.secondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Ad Title
                      AppText(
                        text: ad.title,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                        maxLines: 2,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        margin: const EdgeInsets.only(top: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: AppText(
                          text: "SPONSORED",
                          color: Colors.amber[800],
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
