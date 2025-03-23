import 'package:flutter/material.dart';
import 'package:news_portal/core/ScreenSizeConfig.dart';
import 'package:news_portal/pages/Home/discover_page.dart';
import 'package:news_portal/resources/app_text.dart';
import 'package:news_portal/resources/constant.dart';
import 'package:news_portal/resources/text_heading.dart';
import 'package:news_portal/widgets/breaking_news_widget.dart';
import 'package:news_portal/widgets/forex_slideshow.dart';
import 'package:news_portal/widgets/trending_news_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSizeConfig.of(context);
    double screenHeight = screenSize.height;
    double screenWidth = screenSize.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search_rounded)),
          IconButton(
              onPressed: () {}, icon: Icon(Icons.notifications_none_rounded)),
        ],
      ),
      body: Column(
        children: [
          Container(
              width: screenWidth * 0.95,
              height: 88,
              color: backgroundWhite,
              child: ForexSlideshow()),
          ListTile(
            leading: TextHeading(text: 'Breaking News'),
            trailing: GestureDetector(
              onTap: () {},
              child: AppText(
                text: 'View all',
                color: Colors.blue,
              ),
            ),
          ),
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.27,
              child: BreakingNewsSlider()),
          ListTile(
            leading: TextHeading(text: 'Trending'),
            trailing: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DiscoverPage()));
              },
              child: AppText(
                text: 'View all',
                color: Colors.blue,
              ),
            ),
          ),
          SizedBox(height: 250, child: TrendingNewsCard()),
        ],
      ),
    );
  }
}
