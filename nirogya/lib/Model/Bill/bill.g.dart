// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BillAdapter extends TypeAdapter<Bill> {
  @override
  final int typeId = 3;

  @override
  Bill read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Bill(
      invoiceNumber: fields[0] as String,
      date: fields[1] as DateTime,
      medicines: (fields[2] as List).cast<Medicine>(),
      dealerName: fields[3] as String,
      dealerContact: fields[4] as String,
      gstNumber: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Bill obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.invoiceNumber)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.medicines)
      ..writeByte(3)
      ..write(obj.dealerName)
      ..writeByte(4)
      ..write(obj.dealerContact)
      ..writeByte(5)
      ..write(obj.gstNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BillAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
