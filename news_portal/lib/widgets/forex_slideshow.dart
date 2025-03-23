import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:news_portal/controllers/forex_service.dart';
import 'package:news_portal/core/ScreenSizeConfig.dart';
import 'package:news_portal/models/forex_data_model.dart';
import 'package:news_portal/resources/app_text.dart';
import 'package:news_portal/resources/constant.dart';

class ForexSlideshow extends StatefulWidget {
  const ForexSlideshow({super.key});

  @override
  _ForexSlideshowState createState() => _ForexSlideshowState();
}

class _ForexSlideshowState extends State<ForexSlideshow> {
  late Future<List<ForexRate>> _forexRates;

  @override
  void initState() {
    super.initState();
    _forexRates = ForexService().fetchForexData();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSizeConfig.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
      child: FutureBuilder<List<ForexRate>>(
        future: _forexRates,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No data available"));
          }

          return SizedBox(
            height: 50,
            child: Row(
              children: [
                // Fixed leading card
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "Forex",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                // Forex carousel
                Expanded(
                  child: CarouselSlider(
                    enableAutoSlider: true,
                    autoSliderTransitionTime: const Duration(milliseconds: 800),
                    viewportFraction: 0.3,
                    autoSliderTransitionCurve: Curves.fastOutSlowIn,
                    autoSliderDelay: const Duration(milliseconds: 1500),
                    scrollDirection: Axis.horizontal,
                    unlimitedMode: true,
                    children: snapshot.data!.map((forex) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(color: grey),
                          ),
                        ),
                        child: ForexCard(forex: forex),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ForexCard extends StatelessWidget {
  final ForexRate forex;
  const ForexCard({super.key, required this.forex});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          forex.currencyIso3,
          style: const TextStyle(fontSize: 12),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppText(
              text: 'Buy',
              fontSize: 12,
              color: Colors.blue,
            ),
            const SizedBox(width: 12),
            const AppText(color: Colors.blue, text: 'Sell', fontSize: 12),
          ],
        ),
        AppText(text: "${forex.buy} | ${forex.sell}", fontSize: 12),
      ],
    );
  }
}
