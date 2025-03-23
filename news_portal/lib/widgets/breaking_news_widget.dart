import 'package:flutter/material.dart';
import 'package:news_portal/pages/Home/news_details_page.dart';
import 'package:news_portal/resources/app_text.dart';

class BreakingNewsSlider extends StatefulWidget {
  @override
  _BreakingNewsSliderState createState() => _BreakingNewsSliderState();
}

class _BreakingNewsSliderState extends State<BreakingNewsSlider> {
  final PageController _pageController =
      PageController(initialPage: 1, viewportFraction: 0.85);

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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // News Slider
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _pageController,
            itemCount: newsList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: NewsCard(news: newsList[index]),
              );
            },
          ),
        ),
        // Dots Indicator
        SizedBox(height: 10),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              newsList.length,
              (index) => Container(
                margin: EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          ),
        ),
      ],
    );
    // );
  }
}

// NewsCard Widget
class NewsCard extends StatelessWidget {
  final Map<String, String> news;
  const NewsCard({required this.news});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => NewsDetailsPage()));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
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
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: AppText(
                    text: news["category"]!,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
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
                      SizedBox(width: 6),
                      Icon(Icons.verified, color: Colors.blue, size: 16),
                      SizedBox(width: 6),
                      Text("• ${news["time"]!}",
                          style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                  SizedBox(height: 8),
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
