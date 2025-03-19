// import 'package:flutter/material.dart';
// import 'package:news_portal/resources/app_text.dart';
// import 'package:news_portal/resources/constant.dart';
// import 'package:news_portal/resources/text_subheading.dart';
// import 'package:news_portal/widgets/opaque_bg_icon.dart';

// class NewsDetailsPage extends StatelessWidget {
//   const NewsDetailsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     double screenHeight = MediaQuery.of(context).size.height;
//     double screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       body: Stack(
//         children: [
//           Positioned(
//               top: 0,
//               child: SizedBox(
//                 height: screenHeight * 0.5,
//                 width: screenWidth,
//                 child: Image.network(
//                   'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTtNWZ-rPMwC1C1R9wKDlQsCjP-XE8WzxcMejlBhzXokTw29ohbKbxkpnDI8oaCZm87Px0&usqp=CAU',
//                   fit: BoxFit.cover,
//                 ),
//               )),
//           Positioned(
//             top: 0,
//             child: SizedBox(
//               height: screenHeight * 0.6,
//               width: screenWidth,
//               child: Stack(
//                 children: [
//                   Positioned(
//                     top: screenHeight * 0.02,
//                     child: Row(
//                       children: [
//                         IconButton(
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                           },
//                           icon: const OpaqueBgIcon(icon: Icons.arrow_back),
//                         ),
//                         SizedBox(width: screenWidth * 0.65),
//                         IconButton(
//                           onPressed: () {},
//                           icon: const OpaqueBgIcon(
//                               icon: Icons.bookmark_border_outlined),
//                         ),
//                         IconButton(
//                           onPressed: () {},
//                           icon: const OpaqueBgIcon(icon: Icons.more_horiz),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Positioned(
//                       top: screenHeight * 0.3,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Card(
//                               color: appDarkBlue,
//                               child: const Padding(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: 6, vertical: 3),
//                                 child: AppText(text: 'Sports'),
//                               )),
//                           AppText(
//                               fontSize: 16,
//                               text:
//                                   'Alexander wears modified helmet in road races',
//                               color: white),
//                           SizedBox(
//                             width: screenWidth * 0.3,
//                             child: ListTile(
//                               leading: TextSubHeading(
//                                 text: 'Trending',
//                                 size: 14,
//                                 color: white,
//                               ),
//                               trailing: TextSubHeading(
//                                 text: '6 Hrs ago',
//                                 color: white,
//                                 size: 14,
//                               ),
//                             ),
//                           )
//                         ],
//                       ))
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             top: screenHeight * 0.45,
//             height: screenHeight * 0.5,
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.red,
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(20),
//                   topRight: Radius.circular(20),
//                 ),
//               ),
//               width: screenWidth,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:news_portal/resources/app_text.dart';
import 'package:news_portal/resources/constant.dart';
import 'package:news_portal/resources/text_subheading.dart';
import 'package:news_portal/widgets/opaque_bg_icon.dart';

class NewsDetailsPage extends StatelessWidget {
  const NewsDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
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
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTtNWZ-rPMwC1C1R9wKDlQsCjP-XE8WzxcMejlBhzXokTw29ohbKbxkpnDI8oaCZm87Px0&usqp=CAU',
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
                              .withOpacity(0.1), // Light fade at the top
                          // Colors.black.withOpacity(
                          //     0.3), // Slightly darker in the middle
                          Colors.black.withOpacity(
                              0.7), // Stronger darkness at the bottom
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
            top: screenHeight * 0.02,
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
            top: screenHeight * 0.3,
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
                AppText(
                  fontSize: 16,
                  text: 'Alexander wears modified helmet in road races',
                  color: Colors.white,
                ),
                SizedBox(
                  width: screenWidth * 0.4,
                  child: ListTile(
                    leading: TextSubHeading(
                      text: 'Trending',
                      size: 14,
                      color: Colors.white,
                    ),
                    trailing: TextSubHeading(
                      text: '6 Hrs ago',
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // News Details Container
          Positioned(
            top: screenHeight * 0.45,
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
