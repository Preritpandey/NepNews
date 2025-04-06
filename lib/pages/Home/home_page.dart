import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'discover_page.dart';
import '../../controllers/ads_controller.dart';
import '../../core/ScreenSizeConfig.dart';
import '../../resources/app_text.dart';
import '../../resources/text_heading.dart';
import '../../widgets/breaking_news_widget.dart';
import '../../widgets/forex_slideshow.dart';
import '../../widgets/trending_news_widget.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final AdController adController =
      Get.put(AdController()); // Inject controller

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSizeConfig.of(context);
    double screenHeight = screenSize.height;
    double screenWidth = screenSize.width;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.menu, color: theme.colorScheme.onBackground),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search_rounded,
              color: theme.colorScheme.onBackground,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_none_rounded,
              color: theme.colorScheme.onBackground,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ads will be placed here after more testing and final UI desin.
            // Obx(() {
            //   if (adController.isLoading.value) {
            //     return const CircularProgressIndicator();
            //   } else if (adController.hasError.value) {
            //     return Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Text(
            //         'Failed to load ad: ${adController.errorMessage.value}',
            //         style: TextStyle(color: Colors.red),
            //       ),
            //     );
            //   } else if (adController.ads.isNotEmpty) {
            //     AdModel ad = adController.ads.first; // Show the first ad
            //     return Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: GestureDetector(
            //         onTap: () {
            //           _launchUrl(ad.url);
            //         },
            //         child: Container(
            //           width: screenWidth * 0.95,
            //           height: screenHeight * 0.1,
            //           decoration: BoxDecoration(
            //             image: DecorationImage(
            //               image: NetworkImage(ad.avatar),
            //               fit: BoxFit.cover,
            //             ),
            //             borderRadius: BorderRadius.circular(10),
            //           ),
            //         ),
            //       ),
            //     );
            //   } else {
            //     return const SizedBox(); // No ads available
            //   }
            // }),

            // Forex Slideshow
            Container(
              width: screenWidth * 0.95,
              height: screenHeight * 0.085,
              color: theme.colorScheme.background,
              child: const ForexSlideshow(),
            ),

            // Breaking News Section
            ListTile(
              leading: const TextHeading(text: 'Breaking News'),
              trailing: GestureDetector(
                onTap: () {},
                child: AppText(
                  text: 'View all',
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.27,
              child: BreakingNewsSlider(),
            ),

            // Trending News Section
            ListTile(
              leading: const TextHeading(text: 'Trending', fontSize: 15),
              trailing: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DiscoverPage()),
                  );
                },
                child: AppText(
                  text: 'View all',
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.6,
              child: TrendingNewsCard(),
            ),
          ],
        ),
      ),
    );
  }

  // Launch URL function
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
