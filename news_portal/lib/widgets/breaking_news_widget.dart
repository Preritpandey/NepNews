import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_portal/pages/Home/news_details_page.dart';
import 'package:news_portal/resources/app_text.dart';
import 'package:news_portal/widgets/ad_card.dart';
import '../controllers/ads_controller.dart';
import '../controllers/get_article_controller.dart';
import '../models/ads_data_model.dart';
import '../models/article_model.dart';

class BreakingNewsSlider extends StatefulWidget {
  const BreakingNewsSlider({super.key});

  @override
  BreakingNewsSliderState createState() => BreakingNewsSliderState();
}

class BreakingNewsSliderState extends State<BreakingNewsSlider> {
  final PageController _pageController =
      PageController(initialPage: 0, viewportFraction: 0.85);
  int _currentPage = 0;

  final AdController adController = Get.find<AdController>();
  final GetArticleController articleController =
      Get.find<GetArticleController>();

  List<dynamic> getCombinedList() {
    final List<dynamic> combined = [];
    final List<AdModel> ads = adController.ads;
    final List<ArticleModel> breakingNews = articleController.getBreakingNews();

    int adIndex = 0;
    for (int i = 0; i < breakingNews.length; i++) {
      combined.add(breakingNews[i]);
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
      if (articleController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (articleController.hasError.value) {
        return Center(
          child: Text(
            'Error: ${articleController.errorMessage.value}',
            style: TextStyle(color: theme.colorScheme.error),
          ),
        );
      }

      final combinedList = getCombinedList();

      if (combinedList.isEmpty) {
        return const Center(
          child: Text('No breaking news available'),
        );
      }

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
                  child: item is ArticleModel
                      ? NewsCard(article: item)
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

// NewsCard Widget
class NewsCard extends StatelessWidget {
  final ArticleModel article;
  const NewsCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    // Format the time to show how long ago the article was published
    String timeAgo = '';
    if (article.publishDate != null) {
      final publishDateTime = DateTime.parse(article.publishDate!);
      final now = DateTime.now();
      final difference = now.difference(publishDateTime);

      if (difference.inDays > 0) {
        timeAgo =
            '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
      } else if (difference.inHours > 0) {
        timeAgo =
            '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
      } else if (difference.inMinutes > 0) {
        timeAgo =
            '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
      } else {
        timeAgo = 'Just now';
      }
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailsPage(articleId: article.id),
          ),
        );
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
                  image: NetworkImage(article.avatar),
                  fit: BoxFit.cover,
                  onError: (_, __) => const AssetImage('assets/splash.png'),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 97, 110, 120),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: AppText(
                    text: article.category,
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
                          text: article.author.name,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      const SizedBox(width: 6),
                      const Icon(Icons.verified, color: Colors.blue, size: 16),
                      const SizedBox(width: 6),
                      Text("• $timeAgo",
                          style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // News Headline
                  AppText(
                      text: article.title,
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
