import 'package:flutter/material.dart';
import 'package:news_portal/resources/constant.dart';
import 'package:news_portal/widgets/opaque_bg_icon.dart';

class NewsDetailsPage extends StatelessWidget {
  const NewsDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      // appBar: AppBar(
      //   title: IconButton(
      //       onPressed: () {
      //         Navigator.of(context).pop();
      //       },
      //       icon: OpaqueBgIcon(icon: Icons.arrow_back)),
      //   actions: [
      //     IconButton(
      //         onPressed: () {},
      //         icon: OpaqueBgIcon(icon: Icons.bookmark_border_outlined)),
      //     IconButton(
      //       onPressed: () {},
      //       icon: OpaqueBgIcon(icon: Icons.more_horiz),
      //     )
      //   ],
      // ),
      body: Stack(
        children: [
          Positioned(
              top: 0,
              child: Container(
                height: screenHeight * 0.6,
                width: screenWidth,
                color: darkBlue,
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const OpaqueBgIcon(icon: Icons.arrow_back)),
                    IconButton(
                        onPressed: () {},
                        icon: const OpaqueBgIcon(
                            icon: Icons.bookmark_border_outlined)),
                    IconButton(
                      onPressed: () {},
                      icon: const OpaqueBgIcon(icon: Icons.more_horiz),
                    )
                  ],
                ),
              )),
          Positioned(
              top: screenHeight * 0.5,
              height: screenHeight * 0.5,
              child: Container(
                decoration:  BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )),
                width: screenWidth,
              ))
        ],
      ),
    );
  }
}
