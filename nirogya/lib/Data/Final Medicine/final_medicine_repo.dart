import 'package:hive/hive.dart';
import '../../Model/Final Medicine/final_medicine.dart';

class FinalMedicineRepository {
  static const String _boxName = 'final_medicines';

  Future<Box<FinalMedicine>> _openBox() async {
    return await Hive.openBox<FinalMedicine>(_boxName);
  }

  Future<void> addFinalMedicine(FinalMedicine finalMedicine) async {
    final box = await _openBox();
    await box.put(finalMedicine.id, finalMedicine);
  }

  Future<List<FinalMedicine>> getAllFinalMedicines() async {
    final box = await _openBox();
    return box.values.toList();
  }

  Future<FinalMedicine?> getFinalMedicineById(String id) async {
    final box = await _openBox();
    return box.get(id);
  }

  Future<void> updateFinalMedicine(FinalMedicine finalMedicine) async {
    final box = await _openBox();
    await box.put(finalMedicine.id, finalMedicine);
  }

  Future<void> deleteFinalMedicine(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }

  Future<void> clearAllFinalMedicines() async {
    final box = await _openBox();
    await box.clear();
  }

  // New method to check if a medicine exists and remove it if quantity is zero
  Future<void> checkAndRemoveMedicine(String id) async {
    final box = await _openBox();
    FinalMedicine? finalMedicine = box.get(id);

    if (finalMedicine != null && finalMedicine.medicine.quantity <= 0) {
      await box.delete(id); // Remove medicine if quantity is zero
    }
  }
}