import 'package:flutter/widgets.dart';

class ScreenSizeConfig extends InheritedWidget {
  final double width;
  final double height;
  final double textScaleFactor;

  const ScreenSizeConfig({
    required this.width,
    required this.height,
    required this.textScaleFactor,
    required super.child,
    super.key,
  });

  static ScreenSizeConfig of(BuildContext context) {
    final ScreenSizeConfig? result =
        context.dependOnInheritedWidgetOfExactType<ScreenSizeConfig>();
    assert(result != null, 'No ScreenSizeConfig found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(ScreenSizeConfig oldWidget) =>
      width != oldWidget.width || height != oldWidget.height;
}
