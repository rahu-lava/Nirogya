// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dealer.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DealerAdapter extends TypeAdapter<Dealer> {
  @override
  final int typeId = 1;

  @override
  Dealer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Dealer(
      name: fields[0] as String,
      contactNumber: fields[1] as String,
      gstin: fields[2] as String,
      hasWhatsApp: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Dealer obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.contactNumber)
      ..writeByte(2)
      ..write(obj.gstin)
      ..writeByte(3)
      ..write(obj.hasWhatsApp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DealerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
