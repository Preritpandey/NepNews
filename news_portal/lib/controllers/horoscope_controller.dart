import 'package:get/get.dart';
import 'package:news_portal/controllers/horoscope_service.dart';
import '../models/horoscope_model.dart';

class HoroscopeController extends GetxController {
  final HoroscopeService _horoscopeService = HoroscopeService();
  
  final Rx<HoroscopeModel?> currentHoroscope = Rx<HoroscopeModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool hasError = false.obs;

  Future<void> fetchHoroscope(String sign) async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';
    
    try {
      final horoscope = await _horoscopeService.getDailyHoroscope(sign);
      currentHoroscope.value = horoscope;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}