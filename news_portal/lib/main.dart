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

  Get.put(ThemeController(prefs)); //GetX theme controller initialization
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

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
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeController.themeMode.value,
              home: const Home(),
            ),
          ),
        );
      },
    );
  }
}
