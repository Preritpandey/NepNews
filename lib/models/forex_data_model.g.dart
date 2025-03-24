// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forex_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ForexRateAdapter extends TypeAdapter<ForexRate> {
  @override
  final int typeId = 0;

  @override
  ForexRate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ForexRate(
      currencyIso3: fields[0] as String,
      currencyName: fields[1] as String,
      unit: fields[2] as int,
      buy: fields[3] as double,
      sell: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ForexRate obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.currencyIso3)
      ..writeByte(1)
      ..write(obj.currencyName)
      ..writeByte(2)
      ..write(obj.unit)
      ..writeByte(3)
      ..write(obj.buy)
      ..writeByte(4)
      ..write(obj.sell);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ForexRateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
