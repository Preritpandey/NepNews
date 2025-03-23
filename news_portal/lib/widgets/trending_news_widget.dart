import 'package:flutter/material.dart';
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            final news = newsList[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // News Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      news["imageUrl"]!,
                      width: 100,
                      height: 80,
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
                        AppText(
                          text: news["category"]!,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w700,
                        ),
                        SizedBox(height: 4),
                        // News Title
                        AppText(
                          text: news["title"]!,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        SizedBox(height: 6),
                        // Author and Date
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.grey[300],
                              child: Icon(Icons.person,
                                  size: 12, color: Colors.white),
                            ),
                            SizedBox(width: 6),
                            AppText(
                                text: news["author"]!,
                                fontSize: 13,
                                color: Colors.grey.shade600),
                            SizedBox(width: 8),
                            Text("•",
                                style: TextStyle(color: Colors.grey[600])),
                            SizedBox(width: 8),
                            AppText(
                              text: news["date"]!,
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
