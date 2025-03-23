import 'package:hive/hive.dart';
part "forex_data_model.g.dart";

@HiveType(typeId: 0)
class ForexRate extends HiveObject {
  @HiveField(0)
  String currencyIso3;

  @HiveField(1)
  String currencyName;

  @HiveField(2)
  int unit;

  @HiveField(3)
  double buy;

  @HiveField(4)
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
      currencyIso3: json['currency']['iso3'],
      currencyName: json['currency']['name'],
      unit: json['currency']['unit'],
      buy: json['buy'] != null ? double.parse(json['buy']) : 0.0,
      sell: json['sell'] != null ? double.parse(json['sell']) : 0.0,
    );
  }
}
