// lib/screens/horoscope_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:news_portal/resources/constant.dart';

import '../../controllers/horoscope_controller.dart';
import '../../models/horoscope_model.dart';
import '../../resources/app_text.dart';


class HoroscopeDetailScreen extends StatefulWidget {
  final String sign;

  const HoroscopeDetailScreen({Key? key, required this.sign}) : super(key: key);

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
    // Find the zodiac sign details from the list
    final signInfo = zodiacSigns.firstWhere(
      (sign) => sign['name'] == widget.sign,
      orElse: () => {'name': widget.sign, 'icon': '', 'date': ''},
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.sign} Horoscope'),
        backgroundColor: appBackground,
        elevation: 0,
      ),
      backgroundColor: appBackground,
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (_controller.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                const SizedBox(height: 20),
                AppText(
                  text: 'Error loading horoscope',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: AppText(
                    text: _controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _loadHoroscope,
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        } else if (_controller.currentHoroscope.value == null) {
          return const Center(child: Text('No horoscope available'));
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              _buildHoroscopeHeader(signInfo),
              _buildHoroscopeContent(_controller.currentHoroscope.value!),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHoroscopeHeader(Map<String, dynamic> signInfo) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: bluishGreen,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Text(
            signInfo['icon'],
            style: const TextStyle(fontSize: 60, color: Colors.white),
          ),
          const SizedBox(height: 20),
          AppText(
            text: signInfo['name'],
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          const SizedBox(height: 4),
          AppText(
            text: signInfo['date'],
            fontSize: 16,
            color: Colors.white.withOpacity(0.9),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const AppText(
              text: 'Daily Horoscope',
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHoroscopeContent(HoroscopeModel horoscope) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: MarkdownBody(
            data: horoscope.horoscope,
            styleSheet: MarkdownStyleSheet(
              h1: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              h2: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              h3: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              p: const TextStyle(fontSize: 16, height: 1.5),
              strong: const TextStyle(fontWeight: FontWeight.bold),
              blockquote: const TextStyle(
                fontSize: 16,
                height: 1.5,
                fontStyle: FontStyle.italic,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}