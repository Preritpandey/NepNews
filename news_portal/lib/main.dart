import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:news_portal/core/main_binding.dart';
import 'package:news_portal/pages/OnBoarding/onboarding_page.dart';
import 'package:news_portal/pages/Home/home.dart';
import 'package:news_portal/controllers/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/ScreenSizeConfig.dart';
import 'core/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init(); // Initialize GetStorage
  final prefs = await SharedPreferences.getInstance();
  Get.put(ThemeController(prefs)); // Initialize ThemeController

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final box = GetStorage();
    final hasSeenOnboarding = box.read('onboarding_seen') ?? false;

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = MediaQuery.of(context).size;
        final textScaleFactor = MediaQuery.of(context).textScaleFactor;

        return ScreenSizeConfig(
          width: size.width,
          height: size.height,
          textScaleFactor: textScaleFactor,
          child: GetBuilder<ThemeController>(
            builder: (_) => GetMaterialApp(
              initialBinding: MainBinding(),
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeController.themeMode.value,
              home: hasSeenOnboarding ? const Home() : OnboardingPage(),
            ),
          ),
        );
      },
    );
  }
}
