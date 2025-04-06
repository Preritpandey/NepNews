import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_portal/pages/Home/news_details_page.dart';
import 'package:news_portal/resources/app_text.dart';
import 'package:news_portal/widgets/ad_card.dart';

import '../controllers/ads_controller.dart';
import '../models/ads_data_model.dart';

class BreakingNewsSlider extends StatefulWidget {
  const BreakingNewsSlider({super.key});

  @override
  BreakingNewsSliderState createState() => BreakingNewsSliderState();
}

class BreakingNewsSliderState extends State<BreakingNewsSlider> {
  final PageController _pageController =
      PageController(initialPage: 0, viewportFraction: 0.85);
  int _currentPage = 0;

  final AdController adController = Get.put(AdController());

  final List<Map<String, String>> newsList = [
    {
      "title": "Alexander wears modified helmet in road races",
      "source": "CNN Indonesia",
      "time": "6 hours ago",
      "category": "Sports",
      "imageUrl":
          "https://images.squarespace-cdn.com/content/v1/61782ecbf6567d12f08ba3b9/1647524339004-CU4RMQZ5B4BW66JYB1D7/pexels-nishant-das-3906333.jpg",
    },
    {
      "title": "New AI tech revolutionizing modern industries",
      "source": "Tech Crunch",
      "time": "2 hours ago",
      "category": "Technology",
      "imageUrl":
          "https://images.squarespace-cdn.com/content/v1/61782ecbf6567d12f08ba3b9/1647524339004-CU4RMQZ5B4BW66JYB1D7/pexels-nishant-das-3906333.jpg",
    },
    {
      "title": "Global markets react to economic downturn",
      "source": "BBC News",
      "time": "10 hours ago",
      "category": "Finance",
      "imageUrl":
          "https://images.squarespace-cdn.com/content/v1/61782ecbf6567d12f08ba3b9/1647524339004-CU4RMQZ5B4BW66JYB1D7/pexels-nishant-das-3906333.jpg",
    },
  ];

  List<dynamic> getCombinedList() {
    final List<dynamic> combined = [];
    final List<AdModel> ads = adController.ads;

    int adIndex = 0;
    for (int i = 0; i < newsList.length; i++) {
      combined.add(newsList[i]);
      if ((i + 1) % 2 == 0 && adIndex < ads.length) {
        combined.add(ads[adIndex]);
        adIndex++;
      }
    }

    return combined;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      final combinedList = getCombinedList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // News + Ads Slider
          SizedBox(
            height: 180,
            child: PageView.builder(
              controller: _pageController,
              itemCount: combinedList.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final item = combinedList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: item is Map<String, String>
                      ? NewsCard(news: item)
                      : AdCard(ad: item as AdModel),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          // Dots
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                combinedList.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: _currentPage == index
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onBackground.withOpacity(0.2),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

// class BreakingNewsSlider extends StatefulWidget {
//   @override
//   _BreakingNewsSliderState createState() => _BreakingNewsSliderState();
// }

// class _BreakingNewsSliderState extends State<BreakingNewsSlider> {
//   final PageController _pageController =
//       PageController(initialPage: 1, viewportFraction: 0.85);
//   int _currentPage = 1;

//   @override
//   void initState() {
//     super.initState();
//     _pageController.addListener(() {
//       int next = _pageController.page!.round();
//       if (_currentPage != next) {
//         setState(() {
//           _currentPage = next;
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   final List<Map<String, String>> newsList = [
//     {
//       "title": "Alexander wears modified helmet in road races",
//       "source": "CNN Indonesia",
//       "time": "6 hours ago",
//       "category": "Sports",
//       "imageUrl":
//           "https://images.squarespace-cdn.com/content/v1/61782ecbf6567d12f08ba3b9/1647524339004-CU4RMQZ5B4BW66JYB1D7/pexels-nishant-das-3906333.jpg",
//     },
//     {
//       "title": "New AI tech revolutionizing modern industries",
//       "source": "Tech Crunch",
//       "time": "2 hours ago",
//       "category": "Technology",
//       "imageUrl":
//           "https://images.squarespace-cdn.com/content/v1/61782ecbf6567d12f08ba3b9/1647524339004-CU4RMQZ5B4BW66JYB1D7/pexels-nishant-das-3906333.jpg",
//     },
//     {
//       "title": "Global markets react to economic downturn",
//       "source": "BBC News",
//       "time": "10 hours ago",
//       "category": "Finance",
//       "imageUrl":
//           "https://images.squarespace-cdn.com/content/v1/61782ecbf6567d12f08ba3b9/1647524339004-CU4RMQZ5B4BW66JYB1D7/pexels-nishant-das-3906333.jpg",
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // News Slider
//         SizedBox(
//           height: 180,
//           child: PageView.builder(
//             controller: _pageController,
//             itemCount: newsList.length,
//             itemBuilder: (context, index) {
//               return Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                 child: NewsCard(news: newsList[index]),
//               );
//             },
//           ),
//         ),
//         // Dots Indicator
//         SizedBox(height: 10),
//         Center(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: List.generate(
//               newsList.length,
//               (index) => AnimatedContainer(
//                 duration: Duration(milliseconds: 300),
//                 margin: EdgeInsets.symmetric(horizontal: 4),
//                 width: _currentPage == index ? 24 : 8,
//                 height: 8,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: _currentPage == index
//                       ? theme.colorScheme.primary
//                       : theme.colorScheme.onBackground.withOpacity(0.2),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// NewsCard Widget
class NewsCard extends StatelessWidget {
  final Map<String, String> news;
  const NewsCard({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const NewsDetailsPage()));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            // Background Image
            Container(
              height: 180,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(news["imageUrl"]!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Overlay for readability
            Container(
              height: 180,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                ),
              ),
            ),
            // Category Tag
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 97, 110, 120),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: AppText(
                    text: news["category"]!,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
            ),
            // News Content
            Positioned(
              bottom: 20,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // News Source and Time
                  Row(
                    children: [
                      AppText(
                          text: news["source"]!,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      const SizedBox(width: 6),
                      const Icon(Icons.verified, color: Colors.blue, size: 16),
                      const SizedBox(width: 6),
                      Text("• ${news["time"]!}",
                          style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // News Headline
                  AppText(
                      text: news["title"]!,
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
