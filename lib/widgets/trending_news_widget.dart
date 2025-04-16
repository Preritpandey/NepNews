import 'package:flutter/material.dart';
import 'package:news_portal/core/ScreenSizeConfig.dart';
import 'package:news_portal/resources/app_text.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/ads_controller.dart';
import '../models/ads_data_model.dart';

class TrendingNewsCard extends StatelessWidget {
  final List<Map<String, String>> newsList = [
    {
      "category": "Sports",
      "title": "What Training Do Volleyball Players Need?",
      "author": "McKindney",
      "date": "Feb 27, 2023",
      "imageUrl":
          "https://athlonsports.com/.image/c_limit%2Ccs_srgb%2Cq_auto:good%2Cw_700/MjEzMzAxMTMzNDI1MjU2Mjg1/lionel-messi-injury-concerns-grow-after-inter-miami-cavalier-news.webp",
    },
    {
      "category": "Education",
      "title": "Secondary school places: When do parents find out?",
      "author": "Rosemary",
      "date": "Feb 28, 2023",
      "imageUrl":
          "https://athlonsports.com/.image/c_limit%2Ccs_srgb%2Cq_auto:good%2Cw_700/MjEzMzAxMTMzNDI1MjU2Mjg1/lionel-messi-injury-concerns-grow-after-inter-miami-cavalier-news.webp",
    },
    // {
    //   "category": "Sports",
    //   "title": "What Training Do Volleyball Players Need?",
    //   "author": "McKindney",
    //   "date": "Feb 27, 2023",
    //   "imageUrl":
    //       "https://athlonsports.com/.image/c_limit%2Ccs_srgb%2Cq_auto:good%2Cw_700/MjEzMzAxMTMzNDI1MjU2Mjg1/lionel-messi-injury-concerns-grow-after-inter-miami-cavalier-news.webp",
    // },
  ];

  // Get AdController instance
  final adController = Get.find<AdController>();

  TrendingNewsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = ScreenSizeConfig.of(context);
    double screenHeight = screenSize.height;
    double screenWidth = screenSize.width;

    return Container(
      color: theme.colorScheme.background,
      child: Obx(() {
        // Get all ads
        final allAds = adController.ads;

        // If no ads available, just show news items
        if (allAds.isEmpty) {
          return ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: newsList.length,
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
              return _buildNewsCard(
                  context, newsList[index], screenWidth, screenHeight, theme);
            },
          );
        }

        // Calculate total items (news + ads)
        // We'll add an ad after every 2 news items
        int totalNewsItems = newsList.length;
        int totalAdsToShow = (totalNewsItems / 2).floor();
        int totalItems = totalNewsItems + totalAdsToShow;

        return ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
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
              if (newsIndex >= newsList.length) {
                return const SizedBox();
              }

              // Show news
              final news = newsList[newsIndex];
              return _buildNewsCard(
                  context, news, screenWidth, screenHeight, theme);
            }
          },
        );
      }),
    );
  }

  // Building news card widget
  Widget _buildNewsCard(BuildContext context, Map<String, String> news,
      double screenWidth, double screenHeight, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.only(
          right: screenWidth * 0.03,
          left: screenWidth * 0.03,
          top: screenHeight * 0.015,
          bottom: screenHeight * 0.015),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // News Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              news["imageUrl"]!,
              width: screenWidth * 0.3,
              height: screenHeight * 0.14,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          // News Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: AppText(
                    text: news["category"]!,
                    color: theme.colorScheme.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                // News Title
                AppText(
                  text: news["title"]!,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
                const SizedBox(height: 8),
                // Author and Date
                Row(
                  children: [
                    CircleAvatar(
                      radius: 10,
                      backgroundColor:
                          theme.colorScheme.primary.withOpacity(0.2),
                      child: Icon(
                        Icons.person,
                        size: 12,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    AppText(
                      text: news["author"]!,
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
                      text: news["date"]!,
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
              launch(ad.url);
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
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
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
