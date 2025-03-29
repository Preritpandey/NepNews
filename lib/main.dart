import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:news_portal/core/ScreenSizeConfig.dart';
import 'package:news_portal/models/forex_data_model.dart';
import 'package:news_portal/pages/Home/home.dart';
import 'package:news_portal/controllers/theme_controller.dart';
import 'package:news_portal/core/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ForexRateAdapter());
  await Hive.openBox<ForexRate>('forex_rates');
  final prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeController(prefs),
      child: Consumer<ThemeController>(
        builder: (context, themeController, _) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final size = MediaQueryData.fromView(
                WidgetsBinding.instance.platformDispatcher.views.first,
              ).size;

              return ScreenSizeConfig(
                width: size.width,
                height: size.height,
                textScaleFactor: MediaQuery.textScaleFactorOf(context),
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  themeMode: themeController.themeMode,
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  home: Home(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:news_portal/core/ScreenSizeConfig.dart';
// import 'package:news_portal/models/forex_data_model.dart';
// import 'package:news_portal/pages/Home/home.dart';
// import 'package:news_portal/controllers/theme_controller.dart';

// import 'package:news_portal/core/theme.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'controllers/auth_provider.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Initialize Hive
//   await Hive.initFlutter();
//   Hive.registerAdapter(ForexRateAdapter());
//   await Hive.openBox<ForexRate>('forex_rates');

//   // Initialize SharedPreferences
//   final prefs = await SharedPreferences.getInstance();

//   runApp(MyApp(prefs: prefs));
// }

// class MyApp extends StatelessWidget {
//   final SharedPreferences prefs;
//   const MyApp({super.key, required this.prefs});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => ThemeController(prefs)),
//         ChangeNotifierProvider(
//             create: (_) => AuthProvider()), // ✅ Add AuthProvider
//       ],
//       child: Consumer<ThemeController>(
//         builder: (context, themeController, _) {
//           return LayoutBuilder(
//             builder: (context, constraints) {
//               final size = MediaQueryData.fromView(
//                 WidgetsBinding.instance.platformDispatcher.views.first,
//               ).size;

//               return ScreenSizeConfig(
//                 width: size.width,
//                 height: size.height,
//                 textScaleFactor: MediaQuery.textScaleFactorOf(context),
//                 child: MaterialApp(
//                   debugShowCheckedModeBanner: false,
//                   themeMode: themeController.themeMode,
//                   theme: AppTheme.lightTheme,
//                   darkTheme: AppTheme.darkTheme,
//                   home: Home(),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
