// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'final_medicine.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FinalMedicineAdapter extends TypeAdapter<FinalMedicine> {
  @override
  final int typeId = 4;

  @override
  FinalMedicine read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FinalMedicine(
      id: fields[0] as String,
      medicine: fields[2] as Medicine,
    );
  }

  @override
  void write(BinaryWriter writer, FinalMedicine obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.medicine);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FinalMedicineAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
