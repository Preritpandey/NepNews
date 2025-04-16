import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:news_portal/controllers/auth_controller.dart';

class PageController extends GetxController {
  AuthController authController = Get.put(AuthController());
  final box = GetStorage();
  @override
  void onInit() {
    super.onInit();
    print("oninit triggred");
    if (box.read("user") == "author") {
      Get.snackbar("role", "your role is ${box.read("user")}");
      print('hhhhhhhhhhhhhhh');
    }
  }

  void checkUserScope() {}
}
