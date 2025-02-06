// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_bill.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SalesBillAdapter extends TypeAdapter<SalesBill> {
  @override
  final int typeId = 7;

  @override
  SalesBill read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SalesBill(
      invoiceNumber: fields[0] as String,
      date: fields[1] as DateTime,
      medicines: (fields[2] as List).cast<Medicine>(),
      customerName: fields[3] as String,
      customerContactNumber: fields[4] as String,
      paymentMethod: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SalesBill obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.invoiceNumber)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.medicines)
      ..writeByte(3)
      ..write(obj.customerName)
      ..writeByte(4)
      ..write(obj.customerContactNumber)
      ..writeByte(5)
      ..write(obj.paymentMethod);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SalesBillAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
