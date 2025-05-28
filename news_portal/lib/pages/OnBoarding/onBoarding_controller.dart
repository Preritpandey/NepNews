import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:news_portal/pages/Home/home.dart';

class OnboardingController extends GetxController {
  var currentPage = 0.obs;
  final pageController = PageController();

  void nextPage() {
    if (currentPage.value < onboardingData.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      goToHome();
    }
  }

  void skip() => goToHome();

  void onPageChanged(int index) => currentPage.value = index;

  void goToHome() {
    final box = GetStorage();
    box.write('onboarding_seen', true);
    Get.offAll(() => const Home());
  }

  static const onboardingData = [
    {
      "title": "Welcome to NepNews",
      "subtitle": "Your daily source for the latest news and updates.",
      "image": "assets/splash.png",
    },
    {
      "title": "Stay Updated",
      "subtitle": "Get real-time notifications for breaking news.",
      "image": "assets/news.png",
    },
    {
      "title": "Explore Topics",
      "subtitle": "Read from a wide range of categories you care about.",
      "image": "assets/news2.png",
    },
  ];
}
