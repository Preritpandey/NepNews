import 'package:flutter/material.dart';
import 'package:news_portal/resources/app_text.dart';
import 'package:news_portal/resources/constant.dart';
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
          Positioned(
              top: 0,
              child: SizedBox(
                height: screenHeight * 0.6,
                width: screenWidth,
                child: Image.network(
                  'https://images.squarespace-cdn.com/content/v1/61782ecbf6567d12f08ba3b9/1647524339004-CU4RMQZ5B4BW66JYB1D7/pexels-nishant-das-3906333.jpg',
                  fit: BoxFit.cover,
                ),
              )),
          Positioned(
            top: 0,
            child: SizedBox(
              height: screenHeight * 0.6,
              width: screenWidth,
              child: Stack(
                children: [
                  Positioned(
                    top: screenHeight * 0.02,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const OpaqueBgIcon(icon: Icons.arrow_back),
                        ),
                        SizedBox(width: screenWidth * 0.65),
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
                  ),
                  Positioned(
                      top: screenHeight * 0.3,
                      child: Column(
                        children: [
                          Card(
                              color: appDarkBlue,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 3),
                                child: AppText(text: 'Sports'),
                              )),
                        ],
                      ))
                ],
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.5,
            height: screenHeight * 0.5,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: const BorderRadius.only(
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
