import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:news_portal/models/forex_data_model.dart';

class ForexService {
  final String apiUrl = "https://www.nrb.org.np/api/forex/v1/rates?page=1&per_page=10&from=2024-03-23&to=2024-03-23";

  Future<List<ForexRate>> fetchForexData() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    
    if (connectivityResult != ConnectivityResult.none) {
      // Fetch from API
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> rates = data['data']['payload'][0]['rates'];

        List<ForexRate> forexRates = rates
            .where((rate) => rate['buy'] != null && rate['sell'] != null)
            .map((rate) => ForexRate.fromJson(rate))
            .toList();

        // Save to Hive
        var box = Hive.box<ForexRate>('forex_rates');
        await box.clear();
        await box.addAll(forexRates);

        return forexRates;
      } else {
        throw Exception("Failed to fetch forex data");
      }
    } else {
      // No internet, return from Hive
      var box = Hive.box<ForexRate>('forex_rates');
      return box.values.toList();
    }
  }
}
