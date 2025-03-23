import 'package:flutter/material.dart';
import 'package:news_portal/core/ScreenSizeConfig.dart';
import 'package:news_portal/pages/Home/home.dart';

void main() {
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
            home: Home(),
          ),
        );
      },
    );
  }
}
