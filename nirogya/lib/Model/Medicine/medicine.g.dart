// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MedicineAdapter extends TypeAdapter<Medicine> {
  @override
  final int typeId = 0;

  @override
  Medicine read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Medicine(
      productName: fields[0] as String,
      price: fields[1] as double,
      quantity: fields[2] as int,
      expiryDate: fields[3] as String,
      batch: fields[4] as String,
      dealerName: fields[5] as String,
      gst: fields[6] as int,
      companyName: fields[7] as String?,
      alertQuantity: fields[8] as int?,
      description: fields[9] as String?,
      imagePath: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Medicine obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.productName)
      ..writeByte(1)
      ..write(obj.price)
      ..writeByte(2)
      ..write(obj.quantity)
      ..writeByte(3)
      ..write(obj.expiryDate)
      ..writeByte(4)
      ..write(obj.batch)
      ..writeByte(5)
      ..write(obj.dealerName)
      ..writeByte(6)
      ..write(obj.gst)
      ..writeByte(7)
      ..write(obj.companyName)
      ..writeByte(8)
      ..write(obj.alertQuantity)
      ..writeByte(9)
      ..write(obj.description)
      ..writeByte(10)
      ..write(obj.imagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicineAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
