import 'package:flutter/material.dart';
import 'package:news_portal/core/ScreenSizeConfig.dart';
import 'package:news_portal/pages/Home/discover_page.dart';
import 'package:news_portal/resources/app_text.dart';
import 'package:news_portal/resources/text_heading.dart';
import 'package:news_portal/widgets/breaking_news_widget.dart';
import 'package:news_portal/widgets/forex_slideshow.dart';
import 'package:news_portal/widgets/trending_news_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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
            Container(
              width: screenWidth * 0.95,
              height: screenHeight * 0.085,
              color: theme.colorScheme.background,
              child: ForexSlideshow(),
            ),
            ListTile(
              leading: TextHeading(text: 'Breaking News'),
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
            ListTile(
              leading: TextHeading(text: 'Trending', fontSize: 15),
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
}
