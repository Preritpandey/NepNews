import 'package:flutter/material.dart';
import 'package:news_portal/author/author.dart';
import 'package:news_portal/core/ScreenSizeConfig.dart';
import 'package:news_portal/pages/Browse/browse_page.dart';
import 'package:news_portal/pages/Home/home_page.dart';
import 'package:news_portal/pages/Home/news_details_page.dart';
import 'package:news_portal/pages/Profile/profile_page.dart';
import 'package:news_portal/pages/auth/login_page.dart';
import 'package:news_portal/pages/bookmark/bookmark_page.dart';
import 'package:news_portal/resources/constant.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  final List<Widget> pages = [
    const HomePage(),
    AuthorNewsPage(),
    const BrowsePage(),
    // const NewsDetailsPage(),
    // const BookmarkPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSizeConfig.of(context);
    double screenHeight = screenSize.height;

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: SizedBox(
        height: screenHeight * 0.07,
        child: BottomAppBar(
          elevation: 0,
          color: Colors.transparent,
          shape: const CircularNotchedRectangle(),
          notchMargin: 6.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 0),
              _buildNavItem(Icons.language, 1),
              _buildNavItem(Icons.bookmark, 2),
              _buildNavItem(Icons.person, 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    return IconButton(
      icon: Icon(
        icon,
        color:
            _selectedIndex == index ? navBarActiveIconColor : navBarIconColor,
      ),
      onPressed: () => _onItemTapped(index),
    );
  }
}
