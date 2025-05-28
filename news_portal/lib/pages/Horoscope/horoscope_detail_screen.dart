import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:get/get.dart';

import '../../controllers/horoscope_controller.dart';
import '../../models/horoscope_model.dart';
import '../../resources/app_text.dart';

class HoroscopeDetailScreen extends StatefulWidget {
  final String sign;

  const HoroscopeDetailScreen({super.key, required this.sign});

  @override
  State<HoroscopeDetailScreen> createState() => _HoroscopeDetailScreenState();
}

class _HoroscopeDetailScreenState extends State<HoroscopeDetailScreen> {
  final HoroscopeController _controller = Get.put(HoroscopeController());

  @override
  void initState() {
    super.initState();
    _loadHoroscope();
  }

  Future<void> _loadHoroscope() async {
    await _controller.fetchHoroscope(widget.sign);
  }

  @override
  Widget build(BuildContext context) {
    final signInfo = zodiacSigns.firstWhere(
      (sign) => sign['name'] == widget.sign,
      orElse: () => {'name': widget.sign, 'icon': '', 'date': ''},
    );

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final cardColor = isDarkMode ? const Color(0xFF1A1A1A) : Colors.white;
    final primaryColor =
        const Color(0xFF1E88E5); // Blue accent color from screenshot
    final accentColor = const Color(0xFF42A5F5);
    final textColorMain = isDarkMode ? Colors.white : Colors.black87;
    final textColorSecondary = isDarkMode ? Colors.white70 : Colors.black54;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          '${widget.sign} Horoscope',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          // Background image with overlay
          image: DecorationImage(
            image: const AssetImage('assets/backgroundImage.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.4),
              BlendMode.darken,
            ),
          ),
        ),
        child: Obx(() {
          if (_controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          } else if (_controller.hasError.value) {
            return _buildErrorWidget(Colors.white, primaryColor);
          } else if (_controller.currentHoroscope.value == null) {
            return const Center(
              child:
                  AppText(text: 'No horoscope available', color: Colors.white),
            );
          }

          return SafeArea(
            child: LayoutBuilder(builder: (context, constraints) {
              // Apply responsive design
              final double headerHeight =
                  constraints.maxWidth > 600 ? 260 : 260;
              final double iconSize = constraints.maxWidth > 600 ? 70 : 50;
              final double titleSize = constraints.maxWidth > 600 ? 26 : 22;
              final double dateSize = constraints.maxWidth > 600 ? 18 : 14;

              return Container(
                // Semi-transparent container for better readability
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                    ],
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildHoroscopeHeader(
                        signInfo,
                        primaryColor,
                        accentColor,
                        headerHeight,
                        iconSize,
                        titleSize,
                        dateSize,
                      ),
                      _buildHoroscopeContent(
                        _controller.currentHoroscope.value!,
                        cardColor,
                        textColorMain,
                        textColorSecondary,
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        }),
      ),
      bottomNavigationBar: _buildBottomNavBar(isDarkMode, primaryColor),
    );
  }

  Widget _buildErrorWidget(Color textColor, Color primaryColor) {
    return Container(
      // Semi-transparent overlay for error state
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            const SizedBox(height: 16),
            AppText(
              text: 'Error loading horoscope',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: AppText(
                text: _controller.errorMessage.value,
                textAlign: TextAlign.center,
                color: textColor,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadHoroscope,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHoroscopeHeader(
    Map<String, dynamic> signInfo,
    Color primaryColor,
    Color accentColor,
    double headerHeight,
    double iconSize,
    double titleSize,
    double dateSize,
  ) {
    return Container(
      width: double.infinity,
      height: headerHeight,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon/Symbol
          Text(
            signInfo['icon'],
            style: TextStyle(
              fontSize: iconSize,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 10,
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Sign Name
          AppText(
            text: signInfo['name'],
            fontSize: titleSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          const SizedBox(height: 4),
          // Sign Dates
          AppText(
            text: signInfo['date'],
            fontSize: dateSize,
            color: Colors.white.withOpacity(0.9),
          ),
          const SizedBox(height: 16),
          // Badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.today,
                  color: Colors.white,
                  size: 16,
                ),
                SizedBox(width: 6),
                AppText(
                  text: 'Daily Horoscope',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHoroscopeContent(
    HoroscopeModel horoscope,
    Color cardColor,
    Color textColor,
    Color secondaryTextColor,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Today's date
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.white),
                const SizedBox(width: 8),
                AppText(
                  text:
                      'Today, ${DateTime.now().day} ${_getMonthName(DateTime.now().month)} ${DateTime.now().year}',
                  fontSize: 14,
                  color: Colors.white,
                ),
              ],
            ),
          ),

          // Horoscope content
          Card(
            elevation: 4,
            color: cardColor.withOpacity(0.9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header for the content
                  AppText(
                    text: 'Your Daily Reading',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                  const Divider(height: 24),

                  // Markdown content
                  MarkdownBody(
                    data: horoscope.horoscope,
                    styleSheet: MarkdownStyleSheet(
                      h1: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: textColor),
                      h2: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor),
                      h3: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor),
                      p: TextStyle(fontSize: 16, height: 1.6, color: textColor),
                      strong: TextStyle(
                          fontWeight: FontWeight.bold, color: textColor),
                      blockquote: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        fontStyle: FontStyle.italic,
                        color: secondaryTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Additional content cards - similar to news items in screenshot
          const SizedBox(height: 20),
          const AppText(
            text: 'Horoscope Highlights',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          const SizedBox(height: 12),

          // Highlight cards
          _buildHighlightCard(
            'Love & Relationships',
            'Today brings unexpected romantic opportunities.',
            'favorite',
            cardColor.withOpacity(0.9),
            textColor,
            secondaryTextColor,
          ),
          _buildHighlightCard(
            'Career & Finance',
            'A good day for financial decisions and negotiations.',
            'work',
            cardColor.withOpacity(0.9),
            textColor,
            secondaryTextColor,
          ),
          _buildHighlightCard(
            'Health & Wellness',
            'Focus on mental clarity and emotional balance today.',
            'self_improvement',
            cardColor.withOpacity(0.9),
            textColor,
            secondaryTextColor,
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightCard(
    String title,
    String content,
    String iconName,
    Color cardColor,
    Color textColor,
    Color secondaryTextColor,
  ) {
    return Card(
      elevation: 3,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              _getIconData(iconName),
              color: textColor,
              size: 22,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: title,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    text: content,
                    fontSize: 14,
                    color: secondaryTextColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String name) {
    switch (name) {
      case 'favorite':
        return Icons.favorite;
      case 'work':
        return Icons.work;
      case 'self_improvement':
        return Icons.self_improvement;
      default:
        return Icons.star;
    }
  }

  String _getMonthName(int month) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return monthNames[month - 1];
  }

  Widget _buildBottomNavBar(bool isDarkMode, Color primaryColor) {
    final backgroundColor = isDarkMode
        ? const Color(0xFF1A1A1A).withOpacity(0.9)
        : Colors.white.withOpacity(0.9);
    final itemColor = isDarkMode ? Colors.white70 : Colors.black54;
    final selectedItemColor = primaryColor;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, 'Home', itemColor, false),
            _buildNavItem(Icons.language, 'Explore', itemColor, false),
            _buildNavItem(Icons.bookmark, 'Saved', itemColor, false),
            _buildNavItem(Icons.person, 'Profile', selectedItemColor, true),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
      IconData icon, String label, Color color, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
