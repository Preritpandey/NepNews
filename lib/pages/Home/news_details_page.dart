import 'package:flutter/material.dart';
import 'package:news_portal/core/ScreenSizeConfig.dart';
import 'package:news_portal/resources/app_text.dart';
import 'package:news_portal/resources/constant.dart';
import 'package:news_portal/resources/text_subheading.dart';
import 'package:news_portal/widgets/opaque_bg_icon.dart';

class NewsDetailsPage extends StatelessWidget {
  const NewsDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSizeConfig.of(context);
    double screenHeight = screenSize.height;
    double screenWidth = screenSize.width;

    return Scaffold(
      backgroundColor: transparent,
      body: Stack(
        children: [
          // Background Image with Overlay
          Positioned(
            top: 0,
            child: SizedBox(
              height: screenHeight * 0.5,
              width: screenWidth,
              child: Stack(
                children: [
                  Image.network(
                    'https://scontent.fktm10-1.fna.fbcdn.net/v/t39.30808-6/480498084_1078804920956979_8610893900327937131_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=127cfc&_nc_ohc=4QREK26lKJcQ7kNvgEK-dpm&_nc_oc=AdnlBER_kcpWJraJHFhrrxVJimvY49JiPPAJG49yJX3BTVGZog9a5NN5NOGUuvIDrBk&_nc_zt=23&_nc_ht=scontent.fktm10-1.fna&_nc_gid=0fI3mjzdwBQ2Mmbch2VfqA&oh=00_AYEbV_nWqmizn9cbHB7ydO9mHrjsQq4ZLCI_U-LqrzyEZA&oe=67E5276F',
                    fit: BoxFit.cover,
                    width: screenWidth,
                    height: screenHeight * 0.5,
                  ),
                  // Bottom & Side Overlay
                  Container(
                    width: screenWidth,
                    height: screenHeight * 0.5,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black
                              .withOpacity(0.05), // Reduce opacity at the top
                          Colors.black.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Top Navigation Bar
          Positioned(
            top: screenHeight * 0.0,
            left: 10,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const OpaqueBgIcon(icon: Icons.arrow_back),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const OpaqueBgIcon(
                          icon: Icons.bookmark_border_outlined),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const OpaqueBgIcon(icon: Icons.more_horiz),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // News Content
          Positioned(
            top: screenHeight * 0.33,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  color: appDarkBlue,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    child: AppText(text: 'Sports'),
                  ),
                ),
                const SizedBox(height: 8),
                const AppText(
                  fontSize: 16,
                  text: 'Alexander wears modified helmet in road races',
                  color: Colors.white,
                ),
                SizedBox(
                  width: screenWidth * 0.4,
                  child: ListTile(
                    leading: TextSubheading(
                      text: 'Trending',
                      fontSize: 8,
                      color: white,
                    ),
                    trailing: TextSubheading(
                      text: '6 Hrs ago',
                      color: Colors.white,
                      fontSize: 8,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // News Details Container
          Positioned(
            top: screenHeight * 0.47,
            height: screenHeight * 0.5,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              width: screenWidth,
            ),
          ),
        ],
      ),
    );
  }
}
