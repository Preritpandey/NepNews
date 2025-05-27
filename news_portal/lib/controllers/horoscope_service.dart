import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_constants.dart';
import '../models/horoscope_model.dart';

class HoroscopeService {
  Future<HoroscopeModel> getDailyHoroscope(String sign) async {
    try {
      final response = await http.get(
        Uri.parse('$horoscopeUrl/$sign/daily'),
      );

      if (response.statusCode == 200) {
        return HoroscopeModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load horoscope: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching horoscope: $e');
    }
  }
}
