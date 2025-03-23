import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:news_portal/core/ScreenSizeConfig.dart';
import 'package:news_portal/models/forex_data_model.dart';
import 'package:news_portal/pages/Home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ForexRateAdapter());
  await Hive.openBox<ForexRate>('forex_rates');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
            home: Home(),
          ),
        );
      },
    );
  }
}
