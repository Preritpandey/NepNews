import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:news_portal/models/forex_data_model.dart';

class ForexController extends GetxController {
  final RxList<ForexRate> forexRates = <ForexRate>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  final String apiUrl =
      "https://www.nrb.org.np/api/forex/v1/rates?page=1&per_page=10&from=2024-03-23&to=2024-03-23";
  final GetStorage storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    fetchForexData();
  }

  Future<void> fetchForexData() async {
    isLoading(true);
    hasError(false);
    errorMessage('');

    try {
      var connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult != ConnectivityResult.none) {
        // Fetch from API
        final response = await http.get(Uri.parse(apiUrl));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          List<dynamic> rates = data['data']['payload'][0]['rates'];
          List<ForexRate> fetchedRates = rates
              .where((rate) => rate['buy'] != null && rate['sell'] != null)
              .map((rate) => ForexRate.fromJson(rate))
              .toList();

          // Save to GetStorage
          final List<Map<String, dynamic>> ratesJson =
              fetchedRates.map((rate) => rate.toJson()).toList();
          storage.write('forex_rates', ratesJson);

          // Update controller state
          forexRates.assignAll(fetchedRates);
        } else {
          throw Exception("Failed to fetch forex data");
        }
      } else {
        // No internet, return from GetStorage
        final List<dynamic>? storedRates =
            storage.read<List<dynamic>>('forex_rates');
        if (storedRates != null && storedRates.isNotEmpty) {
          final List<ForexRate> cachedRates = storedRates
              .map((rateJson) => ForexRate.fromJson(rateJson))
              .toList();
          forexRates.assignAll(cachedRates);
        } else {
          hasError(true);
          errorMessage('No cached data available');
        }
      }
    } catch (e) {
      hasError(true);
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }

  void refreshData() {
    fetchForexData();
  }
}
