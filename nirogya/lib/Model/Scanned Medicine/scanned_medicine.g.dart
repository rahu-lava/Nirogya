// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scanned_medicine.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScannedMedicineAdapter extends TypeAdapter<ScannedMedicine> {
  @override
  final int typeId = 5;

  @override
  ScannedMedicine read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScannedMedicine(
      scannedBarcodes: (fields[0] as List).cast<String>(),
      finalMedicine: fields[1] as FinalMedicine,
    );
  }

  @override
  void write(BinaryWriter writer, ScannedMedicine obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.scannedBarcodes)
      ..writeByte(1)
      ..write(obj.finalMedicine);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScannedMedicineAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
