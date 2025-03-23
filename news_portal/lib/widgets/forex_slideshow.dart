import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:news_portal/controllers/forex_service.dart';
import 'package:news_portal/models/forex_data_model.dart';

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
    return Padding(
      padding:const EdgeInsets.all(10),
      child: FutureBuilder<List<ForexRate>>(
        future: _forexRates,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No data available"));
          }

          return SizedBox(
            height: 50,
            child: CarouselSlider(
              enableAutoSlider: true,
              autoSliderTransitionTime: const Duration(milliseconds: 800),
              viewportFraction: 0.3,
              autoSliderTransitionCurve: Curves.fastOutSlowIn,
              autoSliderDelay:const Duration(milliseconds: 1500),
              scrollDirection: Axis.horizontal,
              unlimitedMode: true,
              children: snapshot.data!.map((forex) {
                return ForexCard(forex: forex);
              }).toList(),
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          forex.currencyIso3,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue),
        ),
        Text(
          "${forex.buy} / ${forex.sell}",
          style: TextStyle(fontSize: 14),
        ),
      ],
      // ),
    );
    // );
  }
}
