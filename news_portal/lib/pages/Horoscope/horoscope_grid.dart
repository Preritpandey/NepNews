// lib/screens/horoscope_grid_screen.dart
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Horoscope'),
        backgroundColor: bluishGreen,
        elevation: 0,
      ),
      backgroundColor: appBackground,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: AppText(
                text: 'Select your zodiac sign',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: zodiacSigns.length,
                itemBuilder: (context, index) {
                  return _buildZodiacCard(context, zodiacSigns[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZodiacCard(BuildContext context, Map<String, dynamic> zodiac) {
    return GestureDetector(
      onTap: () {
        Get.to(() => HoroscopeDetailScreen(sign: zodiac['name']));
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                zodiac['icon'],
                style: const TextStyle(fontSize: 40),
              ),
              const SizedBox(height: 20),
              AppText(
                text: zodiac['name'],
                fontSize: 16,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              AppText(
                text: zodiac['date'],
                fontSize: 12,
                color: Colors.yellow,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
