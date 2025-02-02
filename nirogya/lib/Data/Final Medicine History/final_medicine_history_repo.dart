import 'package:hive/hive.dart';
import '../../Model/Final Medicine/final_medicine.dart';

class FinalMedicineHistoryRepository {
  static const String _boxName = 'final_medicine_history';

  Future<Box<FinalMedicine>> _openBox() async {
    return await Hive.openBox<FinalMedicine>(_boxName);
  }

  // Save FinalMedicine data with timestamp as the key
  Future<void> saveFinalMedicineHistory(FinalMedicine finalMedicine) async {
    final box = await _openBox();
    final timestamp = DateTime.now().toIso8601String(); // Use ISO 8601 format
    await box.put(timestamp, finalMedicine);
  }

  // Get all FinalMedicine history entries
  Future<List<Map<String, FinalMedicine>>> getAllFinalMedicineHistory() async {
    final box = await _openBox();
    final history = <Map<String, FinalMedicine>>[];

    for (var key in box.keys) {
      final finalMedicine = box.get(key);
      if (finalMedicine != null) {
        history.add({key: finalMedicine});
      }
    }

    return history;
  }

  // Clear all history entries
  Future<void> clearFinalMedicineHistory() async {
    final box = await _openBox();
    await box.clear();
  }
}