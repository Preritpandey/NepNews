import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';

import '../controllers/forex_controller.dart';
import '../models/forex_data_model.dart';
import '../resources/app_text.dart';
import '../resources/constant.dart';

class ForexSlideshow extends StatelessWidget {
  const ForexSlideshow({super.key});

  @override
  Widget build(BuildContext context) {
    final ForexController forexController = Get.put(ForexController());

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
      child: Obx(() {
        if (forexController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (forexController.hasError.value) {
          return Center(
              child: Text("Error: ${forexController.errorMessage.value}"));
        } else if (forexController.forexRates.isEmpty) {
          return const Center(child: Text("No data available"));
        }

        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: SizedBox(
            height: 50,
            child: Row(
              children: [
                // Fixed leading card
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: const BoxDecoration(
                    color: navBarActiveIconColor,
                    borderRadius:  BorderRadius.only(
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
                    viewportFraction: 0.35,
                    autoSliderTransitionCurve: Curves.fastOutSlowIn,
                    autoSliderDelay: const Duration(milliseconds: 1500),
                    scrollDirection: Axis.horizontal,
                    unlimitedMode: true,
                    children: forexController.forexRates.map((forex) {
                      return Container(
                        decoration: const BoxDecoration(
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
          ),
        );
      }),
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
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText(
              text: 'Buy',
              fontSize: 12,
              color: Colors.blue,
            ),
            SizedBox(width: 15),
            AppText(color: Colors.blue, text: 'Sell', fontSize: 12),
          ],
        ),
        AppText(text: "${forex.buy} | ${forex.sell}", fontSize: 12),
      ],
    );
  }
}
