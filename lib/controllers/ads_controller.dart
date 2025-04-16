import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/ads_data_model.dart';

class AdController extends GetxController {
  // Observable variables
  final RxList<AdModel> ads = <AdModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // API base URL
  // final String baseUrl = 'http://172.20.10.3:8080';
  final String baseUrl = 'http://192.168.1.93:8081';

  @override
  void onInit() {
    fetchAds();
    super.onInit();
  }

  // Fetch all ads
  Future<void> fetchAds() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final response = await http.get(Uri.parse('$baseUrl/ad'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        ads.value = jsonData.map((item) => AdModel.fromJson(item)).toList();
      } else {
        hasError.value = true;
        errorMessage.value =
            'Failed to load ads. Status code: ${response.statusCode}';
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Error fetching ads: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  // Get ads by category
  List<AdModel> getAdsByCategory(String category) {
    return ads.where((ad) => ad.category == category).toList();
  }

  // Get ads by placement
  List<AdModel> getAdsByPlacement(String placement) {
    return ads.where((ad) => ad.placement == placement).toList();
  }

  // Get a single ad by id
  AdModel? getAdById(String id) {
    try {
      return ads.firstWhere((ad) => ad.id == id);
    } catch (e) {
      return null;
    }
  }

  // Refresh ads data
  Future<void> refreshAds() async {
    await fetchAds();
  }

  // Fetch a specific ad by ID from the API
  Future<AdModel?> fetchAdById(String id) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final response = await http.get(Uri.parse('$baseUrl/ad/$id'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return AdModel.fromJson(jsonData);
      } else {
        hasError.value = true;
        errorMessage.value =
            'Failed to load ad. Status code: ${response.statusCode}';
        return null;
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Error fetching ad: ${e.toString()}';
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
