import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_portal/pages/Horoscope/horoscope_detail_screen.dart';
import 'package:news_portal/resources/constant.dart';

import '../../models/horoscope_model.dart';
import '../../resources/app_text.dart';

class HoroscopeGridScreen extends StatelessWidget {
  const HoroscopeGridScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Horoscope'),
        backgroundColor: transparent,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              text: 'Select your zodiac sign',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: zodiacSigns.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final zodiac = zodiacSigns[index];
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => HoroscopeDetailScreen(sign: zodiac['name']));
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: isDark ? Colors.grey[900] : Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 20),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: isDark
                                  ? bluishGreen.withOpacity(0.2)
                                  : bluishGreen.withOpacity(0.1),
                              child: Text(
                                zodiac['icon'],
                                style: const TextStyle(fontSize: 30),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText(
                                    text: zodiac['name'],
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color,
                                  ),
                                  const SizedBox(height: 4),
                                  AppText(
                                    text: zodiac['date'],
                                    fontSize: 14,
                                    color: Colors.amber[700],
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios_rounded,
                                size: 18, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
