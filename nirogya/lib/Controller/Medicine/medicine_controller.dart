import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../../Model/Medicine/medicine.dart';

class MedicineController with ChangeNotifier {
  late Box<Medicine> _medicineBox;
  List<Medicine> _medicines = [];

  /// Getter for the list of medicines
  List<Medicine> get medicines => _medicines;

  /// Initialize the controller and load medicines
  Future<void> initialize() async {
    _medicineBox = await Hive.openBox<Medicine>('medicineBox');
    _loadMedicines();
  }

  /// Load medicines from the Hive box
  void _loadMedicines() {
    _medicines = _medicineBox.values.toList();
    notifyListeners(); // Notify the View to update
  }

  /// Add a new medicine
  Future<void> addMedicine(Medicine medicine) async {
    await _medicineBox.add(medicine);
    _loadMedicines();
  }

  /// Update a medicine at a specific index
  Future<void> updateMedicine(int index, Medicine updatedMedicine) async {
    await _medicineBox.putAt(index, updatedMedicine);
    _loadMedicines();
  }

  /// Delete a medicine by index
  Future<void> deleteMedicine(int index) async {
    await _medicineBox.deleteAt(index);
    _loadMedicines();
  }

  /// Add sample data (for testing purposes)
  // Future<void> addSampleData() async {
  //   final sampleData = [
  //     Medicine(name: 'Paracetamol', expiryDate: DateTime.now().add(Duration(days: 365)), stock: 100),
  //     Medicine(name: 'Ibuprofen', expiryDate: DateTime.now().add(Duration(days: 200)), stock: 50),
  //   ];

  //   await _medicineBox.clear(); // Clear existing data
  //   for (var medicine in sampleData) {
  //     await _medicineBox.add(medicine);
  //   }
  //   _loadMedicines();
  // }
}
