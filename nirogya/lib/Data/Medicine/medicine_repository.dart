import 'package:hive/hive.dart';
import '../../Model/Medicine/medicine.dart';

class MedicineRepository {
  final String _boxName = 'medicines';

  Future<Box<Medicine>> _openBox() async {
    return await Hive.openBox<Medicine>(_boxName);
  }

  Future<void> addMedicine(Medicine medicine) async {
    final box = await _openBox();
    await box.add(medicine);
  }

  Future<List<Medicine>> getAllMedicines() async {
    final box = await _openBox();
    return box.values.toList();
  }

  Future<Medicine?> getMedicineByKey(dynamic key) async {
    final box = await _openBox();
    return box.get(key);
  }

  Future<void> updateMedicine(dynamic key, Medicine updatedMedicine) async {
    final box = await _openBox();
    await box.put(key, updatedMedicine);
  }

  Future<void> deleteMedicine(dynamic key) async {
    final box = await _openBox();
    await box.delete(key);
  }

  Future<void> clearAllMedicines() async {
    final box = await _openBox();
    await box.clear();
  }
}
