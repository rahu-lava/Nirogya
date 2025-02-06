import 'package:hive/hive.dart';
import '../../Model/Scanned Medicine/scanned_medicine.dart';

class AddedMedicineRepository {
  static const String _addedBoxName = 'added_medicines';

  Future<Box<ScannedMedicine>> _openAddedBox() async {
    return await Hive.openBox<ScannedMedicine>(_addedBoxName);
  }

  // Add a new medicine to the repository
  Future<void> addAddedMedicine(ScannedMedicine medicine) async {
    final box = await _openAddedBox();
    await box.put(medicine.finalMedicine.id, medicine);
  }

  // Fetch all added medicines
  Future<List<ScannedMedicine>> getAllAddedMedicines() async {
    final box = await _openAddedBox();
    return box.values.toList();
  }

  // Fetch a specific medicine by its ID
  Future<ScannedMedicine?> getAddedMedicineById(String id) async {
    final box = await _openAddedBox();
    return box.get(id); // Fetch the medicine by ID
  }

  // Update an existing medicine
  Future<void> updateAddedMedicine(ScannedMedicine medicine) async {
    final box = await _openAddedBox();
    await box.put(medicine.finalMedicine.id, medicine); // Update the medicine
  }

  // Delete a medicine by its ID
  Future<void> deleteAddedMedicine(String id) async {
    final box = await _openAddedBox();
    await box.delete(id); // Delete the medicine
  }

  // Clear all medicines from the repository
  Future<void> clearAllAddedMedicines() async {
    final box = await _openAddedBox();
    await box.clear();
  }
}