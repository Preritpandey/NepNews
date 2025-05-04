import 'package:flutter/material.dart';

import '../../core/ScreenSizeConfig.dart';
import '../../resources/constant.dart';
import '../Browse/browse_page.dart';
import '../Profile/profile_page.dart';
import 'home_page.dart';
import 'news_details_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  int _selectedIndex = 0;
  final List<Widget> pages = [
    HomePage(),
    const BrowsePage(),
    const NewsDetailsPage(),
    // const BookmarkPage(),
     ProfilePage(),
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
