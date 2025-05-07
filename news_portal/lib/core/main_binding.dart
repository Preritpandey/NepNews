import 'package:get/get.dart';
import '../controllers/ads_controller.dart';
import '../controllers/get_article_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize controllers
    Get.put(GetArticleController(), permanent: true);
    Get.put(AdController(), permanent: true);
    
  }
}
