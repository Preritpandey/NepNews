import 'package:get/get.dart';

class HamburgerMenuController extends GetxController {
  var isMenuOpen = false.obs;

  void toggleMenu() => isMenuOpen.value = !isMenuOpen.value;

  void closeMenu() => isMenuOpen.value = false;
}
