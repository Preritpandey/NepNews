// import 'package:flutter/material.dart';
// import 'package:news_portal/core/ScreenSizeConfig.dart';
// import 'package:news_portal/pages/Browse/browse_page.dart';
// import 'package:news_portal/pages/Home/home_page.dart';
// import 'package:news_portal/pages/Home/news_details_page.dart';
// import 'package:news_portal/pages/Profile/profile_page.dart';
// import 'package:news_portal/pages/bookmark/bookmark_page.dart';

// class Home extends StatefulWidget {
//   @override
//   _HomeState createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   int _selectedIndex = 0;
//   List pages = [
//     const HomePage(),
//     const BrowsePage(),
//     const BookmarkPage(),
//     const ProfilePage(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenSize = ScreenSizeConfig.of(context);
//     double screenHeight = screenSize.height;
//     return Scaffold(
//       body: pages[_selectedIndex],
//       bottomNavigationBar: SizedBox(
//         height: screenHeight * 0.07,
//         child: BottomAppBar(
//           elevation: 0,
//           color: Colors.transparent,
//           shape: CircularNotchedRectangle(),
//           notchMargin: 6.0,
//           child: Container(
//             padding: EdgeInsets.symmetric(vertical: 0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 _buildNavItem(Icons.home, "Home", 0),
//                 _buildNavItem(Icons.language, "Browse", 1),
//                 _buildNavItem(Icons.bookmark, "Bookmarks", 2),
//                 _buildNavItem(Icons.person, "Profile", 3),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildNavItem(IconData icon, String label, int index) {
//     bool isSelected = _selectedIndex == index;

//     return GestureDetector(
//       onTap: () => _onItemTapped(index),
//       child: AnimatedContainer(
//         duration: Duration(milliseconds: 300),
//         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: isSelected
//             ? BoxDecoration(
//                 color: Colors.blue,
//                 borderRadius: BorderRadius.circular(20),
//               )
//             : BoxDecoration(),
//         child: Row(
//           children: [
//             Icon(
//               icon,
//               color: isSelected ? Colors.white : Colors.grey,
//             ),
//             if (isSelected)
//               Padding(
//                 padding: EdgeInsets.only(left: 8),
//                 child: Text(
//                   label,
//                   style: TextStyle(color: Colors.white, fontSize: 9),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:news_portal/core/ScreenSizeConfig.dart';
import 'package:news_portal/pages/Browse/browse_page.dart';
import 'package:news_portal/pages/Home/home_page.dart';
import 'package:news_portal/pages/Profile/profile_page.dart';
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
    const BrowsePage(),
    const BookmarkPage(),
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
