import 'package:flutter/material.dart';
import 'package:news_portal/core/ScreenSizeConfig.dart';
import 'package:news_portal/resources/app_text.dart';

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
          "https://eu-images.contentstack.com/v3/assets/blta90d05ad41a54a71/bltd8fe70dac50fed5e/64a42ccdd715265747807768/La_Liga_EA_Sports.png",
    },
    {
      "category": "Sports",
      "title": "What Training Do Volleyball Players Need?",
      "author": "McKindney",
      "date": "Feb 27, 2023",
      "imageUrl":
          "https://athlonsports.com/.image/c_limit%2Ccs_srgb%2Cq_auto:good%2Cw_700/MjEzMzAxMTMzNDI1MjU2Mjg1/lionel-messi-injury-concerns-grow-after-inter-miami-cavalier-news.webp",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = ScreenSizeConfig.of(context);
    double screenHeight = screenSize.height;
    double screenWidth = screenSize.width;
    return Container(
      color: theme.colorScheme.background,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            final news = newsList[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
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
                    SizedBox(width: 12),
                    // News Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
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
                          SizedBox(height: 8),
                          // News Title
                          AppText(
                            text: news["title"]!,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                          SizedBox(height: 8),
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
                              SizedBox(width: 6),
                              AppText(
                                text: news["author"]!,
                                fontSize: 13,
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.7),
                              ),
                              SizedBox(width: 8),
                              Text(
                                "•",
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.7),
                                ),
                              ),
                              SizedBox(width: 8),
                              AppText(
                                text: news["date"]!,
                                fontSize: 13,
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.7),
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
          },
        ),
      ),
    );
  }
}
