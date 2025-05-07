import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_portal/resources/app_text.dart';

import '../../controllers/get_article_controller.dart';
import '../../models/article_model.dart';

class NewsDetailsPage extends StatelessWidget {
  final String articleId;

  const NewsDetailsPage({super.key, required this.articleId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final GetArticleController articleController = Get.find<GetArticleController>();
    final ArticleModel? article = articleController.getArticleById(articleId);

    if (article == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Article Not Found')),
        body: const Center(
            child: Text('The requested article could not be found')),
      );
    }

    // Format the publish date
    String formattedDate = '';
    if (article.publishDate != null) {
      final publishDate = DateTime.parse(article.publishDate!);
      formattedDate =
          '${publishDate.day}/${publishDate.month}/${publishDate.year} ${publishDate.hour}:${publishDate.minute.toString().padLeft(2, '0')}';
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                article.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black,
                      offset: Offset(0.0, 0.0),
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    article.avatar,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/splash.png',
                          fit: BoxFit.cover);
                    },
                  ),
                  // Gradient overlay for better text readability
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                        colors: [Colors.black54, Colors.transparent],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Article Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category + Date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: AppText(
                          text: article.category,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Author info
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: theme.colorScheme.primary,
                        child: Text(
                          article.author.name.isNotEmpty
                              ? article.author.name[0].toUpperCase()
                              : 'A',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            article.author.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (article.editor != null)
                            Text(
                              'Edited by ${article.editor!.name}',
                              style: TextStyle(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.6),
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Article content
                  Text(
                    article.content,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Keywords
                  if (article.keywords.isNotEmpty) ...[
                    const Text(
                      'Keywords',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: article.keywords.map((keyword) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '#$keyword',
                            style: TextStyle(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// import '../../core/ScreenSizeConfig.dart';
// import '../../resources/app_text.dart';
// import '../../resources/constant.dart';
// import '../../resources/long_text.dart';
// import '../../resources/text.dart';
// import '../../resources/text_heading.dart';
// import '../../resources/text_subheading.dart';
// import '../../widgets/opaque_bg_icon.dart';

// class NewsDetailsPage extends StatelessWidget {
//   const NewsDetailsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final screenSize = ScreenSizeConfig.of(context);
//     double screenHeight = screenSize.height;
//     double screenWidth = screenSize.width;
//     double statusBarHeight = MediaQuery.of(context).padding.top;
//     final theme = Theme.of(context);

//     return Scaffold(
//       backgroundColor: theme.colorScheme.background,
//       body: Stack(
//         children: [
//           // Background Image with Overlay
//           Positioned(
//             top: 0,
//             child: ClipRRect(
//               borderRadius: const BorderRadius.only(
//                   bottomLeft: Radius.circular(20),
//                   bottomRight: Radius.circular(20)),
//               child: SizedBox(
//                 height: screenHeight * 0.4,
//                 width: screenWidth,
//                 child: Stack(
//                   children: [
//                     Image.network(
//                       'https://images.squarespace-cdn.com/content/v1/61782ecbf6567d12f08ba3b9/1647524339004-CU4RMQZ5B4BW66JYB1D7/pexels-nishant-das-3906333.jpg',
//                       fit: BoxFit.cover,
//                       width: screenWidth,
//                       height: screenHeight * 0.4,
//                     ),
//                     // Bottom & Side Overlay
//                     Container(
//                       width: screenWidth,
//                       height: screenHeight * 0.5,
//                       clipBehavior: Clip.antiAlias,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),
//                         gradient: LinearGradient(
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                           colors: [
//                             Colors.black
//                                 .withOpacity(0.05), // Reduce opacity at the top
//                             Colors.black.withOpacity(0.6),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),

//           // Top Navigation Bar
//           Positioned(
//             top: screenHeight * 0.0,
//             left: 10,
//             right: 10,
//             child: Padding(
//               padding: EdgeInsets.only(top: statusBarHeight),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   IconButton(
//                     onPressed: () => Navigator.of(context).pop(),
//                     icon: const OpaqueBgIcon(icon: Icons.arrow_back),
//                   ),
//                   Row(
//                     children: [
//                       IconButton(
//                         onPressed: () {},
//                         icon: const OpaqueBgIcon(
//                             icon: Icons.bookmark_border_outlined),
//                       ),
//                       IconButton(
//                         onPressed: () {},
//                         icon: const OpaqueBgIcon(icon: Icons.more_horiz),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // News Content
//           Positioned(
//             top: screenHeight * 0.24,
//             left: 16,
//             right: 16,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Card(
//                   color: appDarkBlue,
//                   child: const Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
//                     child: AppText(text: 'Sports'),
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 const AppText(
//                   fontSize: 16,
//                   text: 'Alexander wears modified helmet in road races',
//                   color: Colors.white,
//                 ),
//                 SizedBox(
//                   width: screenWidth * 0.4,
//                   child: const ListTile(
//                     leading: TextSubheading(
//                       text: 'Trending',
//                       fontSize: 8,
//                       color: white,
//                     ),
//                     trailing: TextSubheading(
//                       text: '6 Hrs ago',
//                       color: Colors.white,
//                       fontSize: 8,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // News Details Container
//           Positioned(
//             top: screenHeight * 0.42,
//             width: screenWidth,
//             child: Padding(
//               padding: EdgeInsets.only(
//                   left: screenWidth * 0.03, right: screenWidth * 0.03),
//               child: Column(
//                 children: [
//                   SizedBox(
//                     height: screenHeight * 0.06,
//                     width: screenWidth * 0.8,
//                     child: const Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(
//                           width: 3, // Fixed width for VerticalDivider
//                           child: VerticalDivider(
//                             color: appOrange,
//                             thickness: 3,
//                           ),
//                         ),
//                         SizedBox(width: 8),
//                         Expanded(
//                           child: TextHeading(
//                             text: 'Race for champions trophy gets interesting',
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const LongText(text: longString),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
