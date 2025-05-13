// lib/models/horoscope_model.dart
class HoroscopeModel {
  final String sign;
  final String period;
  final String horoscope;

  HoroscopeModel({
    required this.sign,
    required this.period,
    required this.horoscope,
  });

  factory HoroscopeModel.fromJson(Map<String, dynamic> json) {
    return HoroscopeModel(
      sign: json['sign'] ?? '',
      period: json['period'] ?? '',
      horoscope: json['horoscope'] ?? '',
    );
  }
}

// List of all zodiac signs
List<Map<String, dynamic>> zodiacSigns = [
  {'name': 'Aries', 'icon': '♈', 'date': 'Mar 21 - Apr 19'},
  {'name': 'Taurus', 'icon': '♉', 'date': 'Apr 20 - May 20'},
  {'name': 'Gemini', 'icon': '♊', 'date': 'May 21 - Jun 20'},
  {'name': 'Cancer', 'icon': '♋', 'date': 'Jun 21 - Jul 22'},
  {'name': 'Leo', 'icon': '♌', 'date': 'Jul 23 - Aug 22'},
  {'name': 'Virgo', 'icon': '♍', 'date': 'Aug 23 - Sep 22'},
  {'name': 'Libra', 'icon': '♎', 'date': 'Sep 23 - Oct 22'},
  {'name': 'Scorpio', 'icon': '♏', 'date': 'Oct 23 - Nov 21'},
  {'name': 'Sagittarius', 'icon': '♐', 'date': 'Nov 22 - Dec 21'},
  {'name': 'Capricorn', 'icon': '♑', 'date': 'Dec 22 - Jan 19'},
  {'name': 'Aquarius', 'icon': '♒', 'date': 'Jan 20 - Feb 18'},
  {'name': 'Pisces', 'icon': '♓', 'date': 'Feb 19 - Mar 20'},
];
