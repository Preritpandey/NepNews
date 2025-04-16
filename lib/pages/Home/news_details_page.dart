import 'package:flutter/material.dart';

import '../../core/ScreenSizeConfig.dart';
import '../../resources/app_text.dart';
import '../../resources/constant.dart';
import '../../resources/long_text.dart';
import '../../resources/text.dart';
import '../../resources/text_heading.dart';
import '../../resources/text_subheading.dart';
import '../../widgets/opaque_bg_icon.dart';

class NewsDetailsPage extends StatelessWidget {
  const NewsDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSizeConfig.of(context);
    double screenHeight = screenSize.height;
    double screenWidth = screenSize.width;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Stack(
        children: [
          // Background Image with Overlay
          Positioned(
            top: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
              child: SizedBox(
                height: screenHeight * 0.4,
                width: screenWidth,
                child: Stack(
                  children: [
                    Image.network(
                      'https://images.squarespace-cdn.com/content/v1/61782ecbf6567d12f08ba3b9/1647524339004-CU4RMQZ5B4BW66JYB1D7/pexels-nishant-das-3906333.jpg',
                      fit: BoxFit.cover,
                      width: screenWidth,
                      height: screenHeight * 0.4,
                    ),
                    // Bottom & Side Overlay
                    Container(
                      width: screenWidth,
                      height: screenHeight * 0.5,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
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
          ),

          // Top Navigation Bar
          Positioned(
            top: screenHeight * 0.0,
            left: 10,
            right: 10,
            child: Padding(
              padding: EdgeInsets.only(top: statusBarHeight),
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
          ),

          // News Content
          Positioned(
            top: screenHeight * 0.24,
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
                  child: const ListTile(
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
            top: screenHeight * 0.42,
            width: screenWidth,
            child: Padding(
              padding: EdgeInsets.only(
                  left: screenWidth * 0.03, right: screenWidth * 0.03),
              child: Column(
                children: [
                  SizedBox(
                    height: screenHeight * 0.06,
                    width: screenWidth * 0.8,
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 3, // Fixed width for VerticalDivider
                          child: VerticalDivider(
                            color: appOrange,
                            thickness: 3,
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: TextHeading(
                            text: 'Race for champions trophy gets interesting',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const LongText(text: longString),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
