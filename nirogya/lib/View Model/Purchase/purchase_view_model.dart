// import 'package:flutter/foundation.dart';
// import 'package:nirogya/Model/Medicine/medicine.dart';
// import 'package:nirogya/Data/Medicine/medicine_repository.dart';

// class MedicineViewModel extends ChangeNotifier {
//   final MedicineRepository medicineRepo = MedicineRepository();
//   List<Medicine> _medicines = [];
//   List<Medicine> _temp_medicines = [];
//   bool _status = false;

//   List<Medicine> get medicines => _medicines;
//   List<Medicine> get tempMedicines => _temp_medicines;
//   bool get status => _status;
//   bool get isEmpty => _medicines.isEmpty;

//   Future<void> saveTempMeds(Medicine medicine) async {
//     _temp_medicines.add(medicine);
//     notifyListeners();
//   }

//   Future<void> fetchMedicines() async {
//     _medicines = await medicineRepo.getAllMedicines();
//     notifyListeners(); // Notify the UI to rebuild
//   }

//   Future<Medicine?> getMedicineByKey(dynamic key) async {
//     return await medicineRepo.getMedicineByKey(key);
//   }

//   Future<void> addMedicine(Medicine medicine) async {
//     try {
//       await medicineRepo.addMedicine(medicine);
//       _status = true;
//     } catch (e) {
//       print(e);
//       _status = false;
//     }
//     await fetchMedicines(); // Refresh the state after adding
//   }

//   Future<void> updateMedicine(dynamic key, Medicine updatedMedicine) async {
//     try {
//       await medicineRepo.updateMedicine(key, updatedMedicine);
//       _status = true;
//     } catch (e) {
//       print(e);
//       _status = false;
//     }
//     await fetchMedicines(); // Refresh the state after updating
//   }

//   Future<void> deleteMedicine(dynamic key) async {
//     try {
//       await medicineRepo.deleteMedicine(key);
//       _status = true;
//     } catch (e) {
//       print(e);
//       _status = false;
//     }
//     await fetchMedicines(); // Refresh the state after deletion
//   }

//   Future<void> clearAllMedicines() async {
//     try {
//       await medicineRepo.clearAllMedicines();
//       _status = true;
//       _medicines = [];
//     } catch (e) {
//       print(e);
//       _status = false;
//     }
//     notifyListeners();
//   }
// }
