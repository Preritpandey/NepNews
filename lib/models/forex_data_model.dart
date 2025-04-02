import 'package:get/get.dart';

class ForexRate {
  String currencyIso3;
  String currencyName;
  int unit;
  double buy;
  double sell;

  ForexRate({
    required this.currencyIso3,
    required this.currencyName,
    required this.unit,
    required this.buy,
    required this.sell,
  });

  factory ForexRate.fromJson(Map<String, dynamic> json) {
    return ForexRate(
      currencyIso3: json['currency'] != null
          ? json['currency']['iso3'] ?? ''
          : json['currencyIso3'] ?? '',
      currencyName: json['currency'] != null
          ? json['currency']['name'] ?? ''
          : json['currencyName'] ?? '',
      unit: json['currency'] != null
          ? json['currency']['unit'] ?? 1
          : json['unit'] ?? 1,
      buy: json['buy'] != null
          ? double.tryParse(json['buy'].toString()) ?? 0.0
          : json['buy'] ?? 0.0,
      sell: json['sell'] != null
          ? double.tryParse(json['sell'].toString()) ?? 0.0
          : json['sell'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currencyIso3': currencyIso3,
      'currencyName': currencyName,
      'unit': unit,
      'buy': buy,
      'sell': sell,
    };
  }

  // Helper to create a copy with updated values
  ForexRate copyWith({
    String? currencyIso3,
    String? currencyName,
    int? unit,
    double? buy,
    double? sell,
  }) {
    return ForexRate(
      currencyIso3: currencyIso3 ?? this.currencyIso3,
      currencyName: currencyName ?? this.currencyName,
      unit: unit ?? this.unit,
      buy: buy ?? this.buy,
      sell: sell ?? this.sell,
    );
  }
}
