import 'package:flutter/foundation.dart';
import 'package:nirogya/Model/Medicine/medicine.dart';
import 'package:nirogya/Data/Medicine/medicine_repository.dart';

class MedicineViewModel extends ChangeNotifier {
  final MedicineRepository _controller = MedicineRepository();
  List<Medicine> _medicines = [];
  bool _status = false;

  List<Medicine> get medicines => _medicines;
  bool get status => _status;
  bool get isEmpty => _medicines.isEmpty;

  Future<void> fetchMedicines() async {
    _medicines = await _controller.getAllMedicines();
    notifyListeners(); // Notify the UI to rebuild
  }

  Future<Medicine?> getMedicineByKey(dynamic key) async {
    return await _controller.getMedicineByKey(key);
  }

  Future<void> addMedicine(Medicine medicine) async {
    try {
      await _controller.addMedicine(medicine);
      _status = true;
    } catch (e) {
      print(e);
      _status = false;
    }
    await fetchMedicines(); // Refresh the state after adding
  }

  Future<void> updateMedicine(dynamic key, Medicine updatedMedicine) async {
    try {
      await _controller.updateMedicine(key, updatedMedicine);
      _status = true;
    } catch (e) {
      print(e);
      _status = false;
    }
    await fetchMedicines(); // Refresh the state after updating
  }

  Future<void> deleteMedicine(dynamic key) async {
    try {
      await _controller.deleteMedicine(key);
      _status = true;
    } catch (e) {
      print(e);
      _status = false;
    }
    await fetchMedicines(); // Refresh the state after deletion
  }

  Future<void> clearAllMedicines() async {
    try {
      await _controller.clearAllMedicines();
      _status = true;
      _medicines = [];
    } catch (e) {
      print(e);
      _status = false;
    }
    notifyListeners();
  }
}
