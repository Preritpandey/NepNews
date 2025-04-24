import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  final SharedPreferences prefs;
  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  ThemeController(this.prefs) {
    loadThemeMode();
  }

  void loadThemeMode() {
    final savedMode = prefs.getString('themeMode');
    if (savedMode != null) {
      themeMode.value = ThemeMode.values.firstWhere(
        (e) => e.toString() == savedMode,
        orElse: () => ThemeMode.system,
      );
    }
  }

  void setThemeMode(ThemeMode mode) {
    themeMode.value = mode;
    prefs.setString('themeMode', mode.toString());
    update();
  }

  void toggleTheme() {
    if (themeMode.value == ThemeMode.dark) {
      themeMode.value = ThemeMode.light;
    } else {
      themeMode.value = ThemeMode.dark;
    }
    prefs.setString('themeMode', themeMode.value.toString());
    update();
  }

  bool get isDarkMode => themeMode.value == ThemeMode.dark;
}
