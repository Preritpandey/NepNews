import 'package:flutter/material.dart';
import 'package:news_portal/resources/app_text.dart';
import 'package:news_portal/resources/text_heading.dart';
import 'package:news_portal/widgets/breaking_news_widget.dart';
import 'package:news_portal/widgets/trending_news_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
          ListTile(
            leading: TextHeading(text: 'Breaking News'),
            trailing: AppText(
              text: 'View all',
              color: Colors.blue,
            ),
          ),
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.27,
              child: BreakingNewsSlider()),
          ListTile(
            leading: TextHeading(text: 'Trending'),
            trailing: AppText(
              text: 'View all',
              color: Colors.blue,
            ),
          ),
          Expanded(child: TrendingNewsCard()),
        ],
      ),
    );
  }
}
