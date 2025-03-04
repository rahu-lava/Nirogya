import 'package:hive/hive.dart';
import 'package:nirogya/Model/Medicine/medicine.dart';
import 'package:nirogya/Data/Medicine/medicine_repository.dart';

class MedicineQueueRepository {
  final String _boxName = 'medicineQueue';

  /// Opens the Hive box for storing medicines in the queue.
  Future<Box<Medicine>> _openBox() async {
    return await Hive.openBox<Medicine>(_boxName);
  }

  /// Adds a medicine to the queue (temporary storage).
  Future<void> addMedicineToQueue(Medicine medicine) async {
    final box = await _openBox();
    await box.add(medicine);
  }

  /// Retrieves all medicines from the queue.
  Future<List<Medicine>> getAllMedicinesInQueue() async {
    final box = await _openBox();
    return box.values.toList();
  }

  /// Transfers medicines from the queue to the main medicine database (real DB).
  Future<void> transferMedicinesToRealDB() async {
    final box = await _openBox();
    final medicinesInQueue = box.values.toList();

    // Transfer each medicine to the main Medicine database
    final medicineRepo =
        MedicineRepository(); // Assuming you already have a repository for the real DB

    for (var medicine in medicinesInQueue) {
      await medicineRepo
          .addMedicine(medicine); // Adding medicine to the real database
    }
  }

  /// Generates 100 sample medicines for testing.
  // Future<void> generateSampleMedicines() async {
  //   final box = await _openBox();
  //   if (box.isEmpty) {
  //     for (var i = 0; i < 45; i++) {
  //       final medicine = Medicine(
  //         productName: "Medicine ${i + 1}",
  //         price: (i + 1) * 10.0,
  //         quantity: i + 5,
  //         expiryDate: "${(i % 12) + 1}/2025",
  //         batch: "Batch: ${String.fromCharCode(65 + (i % 26))}123",
  //         dealerName: "Dealer ${i + 1}",
  //         gst: 18,
  //         companyName: "Company ${i + 1}",
  //         alertQuantity: 10,
  //         description: "Sample medicine ${i + 1}",
  //         imagePath: null,
  //       );
  //       await box.add(medicine);
  //     }
  //   }
  // }

  /// Clears all medicines from the queue after they have been transferred.
  Future<void> clearQueue() async {
    final box = await _openBox();
    await box.clear();
  }

  /// Removes a specific medicine from the queue by its key.
  Future<void> removeMedicineFromQueue(dynamic key) async {
    final box = await _openBox();
    await box.delete(key);
  }
}
