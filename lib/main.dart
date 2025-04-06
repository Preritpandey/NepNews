import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controllers/theme_controller.dart';
import 'core/ScreenSizeConfig.dart';
import 'core/theme.dart';
import 'pages/Home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  await GetStorage.init(); // Initialize GetStorage

  //  GetX theme controller initialization
  Get.put(ThemeController(prefs));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return GetBuilder<ThemeController>(
      builder: (_) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeController.themeMode.value,
        home: LayoutBuilder(
          builder: (context, constraints) {
            final size = MediaQueryData.fromView(
              WidgetsBinding.instance.platformDispatcher.views.first,
            ).size;

            return ScreenSizeConfig(
              width: size.width,
              height: size.height,
              textScaleFactor: MediaQuery.textScaleFactorOf(context),
              child: const Home(),
            );
          },
        ),
      ),
    );
  }
}
