import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_portal/pages/Home/category_page.dart';
import 'package:news_portal/pages/Horoscope/horoscope_grid.dart';
import 'package:news_portal/widgets/article_search_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/hamburger_menu_controller.dart';
import '../../controllers/get_article_controller.dart'; // Import the article controller
import '../../widgets/categories_menu.dart';
import 'discover_page.dart';
import '../../controllers/ads_controller.dart';
import '../../core/ScreenSizeConfig.dart';
import '../../resources/app_text.dart';
import '../../resources/text_heading.dart';
import '../../widgets/breaking_news_widget.dart';
import '../../widgets/forex_slideshow.dart';
import '../../widgets/trending_news_widget.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final AdController adController = Get.put(AdController());
  final HamburgerMenuController menuController =
      Get.put(HamburgerMenuController());
  final GetArticleController articleController =
      Get.find<GetArticleController>(); // Get the article controller

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSizeConfig.of(context);
    double screenHeight = screenSize.height;
    double screenWidth = screenSize.width;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          ArticleSearchWidget(),
        ],
      ),
      body: Stack(
        children: [
          // Main content with RefreshIndicator
          RefreshIndicator(
            onRefresh: () => _refreshData(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    width: screenWidth * 0.95,
                    height: screenHeight * 0.085,
                    color: theme.colorScheme.background,
                    child: const ForexSlideshow(),
                  ),
                  ListTile(
                    leading: const TextHeading(text: 'Breaking News'),
                    trailing: GestureDetector(
                      onTap: () {
                        Get.to(() => CategoryPage());
                      },
                      child: AppText(
                        text: 'View all',
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.27,
                    child: const BreakingNewsSlider(),
                  ),
                  ListTile(
                    leading: const TextHeading(text: 'Trending', fontSize: 15),
                    trailing: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoryPage()),
                        );
                      },
                      child: AppText(
                        text: 'View all',
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.7,
                    child: TrendingNewsCard(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    child: SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Get.to(() => const HoroscopeGridScreen());
                        },
                        icon: SizedBox(
                          height: 50,
                          width: 50,
                          child: Image.asset('assets/horoscope.png'),
                        ),
                        label: const Text(
                          "See Horoscope",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          // Slide-in menu
          CategoryMenu(),

          // Tap-outside-to-close overlay
          Obx(() {
            return menuController.isMenuOpen.value
                ? Positioned.fill(
                    child: GestureDetector(
                      onTap: () => menuController.closeMenu(),
                      child: Container(color: Colors.black.withOpacity(0.3)),
                    ),
                  )
                : const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  // Method to refresh data when pulling down
  Future<void> _refreshData() async {
    // Call the refresh method from your article controller
    articleController.refreshArticles();

    // You can also refresh other data if needed
    // For example: someOtherController.refreshData();

    // Return a completed future since refreshArticles() is void
    return Future.value();
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar(
        'Error',
        'Could not launch $url',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
