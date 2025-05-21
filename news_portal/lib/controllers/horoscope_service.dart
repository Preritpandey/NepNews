import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/horoscope_model.dart';

class HoroscopeService {
  static const String baseUrl = 'http://192.168.119.148:8082/api/horoscope';

  Future<HoroscopeModel> getDailyHoroscope(String sign) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/horoscope/$sign/daily'),
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
