import 'package:hive/hive.dart';
import '../../Model/Final Medicine/final_medicine.dart';
import '../../Model/Medicine/medicine.dart';

class ScannedMedicineRepository {
  static const String _scannedBoxName = 'scanned_medicines';
  static const String _finalBoxName = 'final_medicines';

  Future<Box<FinalMedicine>> _openScannedBox() async {
    return await Hive.openBox<FinalMedicine>(_scannedBoxName);
  }

  Future<Box<FinalMedicine>> _openFinalBox() async {
    return await Hive.openBox<FinalMedicine>(_finalBoxName);
  }

  Future<void> transferMedicine(String id) async {
    final finalBox = await _openFinalBox();
    final scannedBox = await _openScannedBox();

    FinalMedicine? finalMedicine = finalBox.get(id);

    if (finalMedicine != null && finalMedicine.medicine.quantity > 0) {
      // Reduce quantity in FinalMedicine by 1
      finalMedicine.medicine.quantity -= 1;
      await finalBox.put(id, finalMedicine);

      // Check if the medicine already exists in the ScannedMedicine box
      FinalMedicine? scannedMedicine = scannedBox.get(id);

      if (scannedMedicine != null) {
        // Increase quantity in ScannedMedicine by 1
        scannedMedicine.medicine.quantity += 1;
        await scannedBox.put(id, scannedMedicine);
      } else {
        // Create a new ScannedMedicine entry with quantity 1
        FinalMedicine newScannedMedicine = FinalMedicine(
          id: id,
          medicine: Medicine(
            productName: finalMedicine.medicine.productName,
            price: finalMedicine.medicine.price,
            quantity: 1, // Initial quantity is 1
            expiryDate: finalMedicine.medicine.expiryDate,
            batch: finalMedicine.medicine.batch,
            dealerName: finalMedicine.medicine.dealerName,
            gst: finalMedicine.medicine.gst,
            companyName: finalMedicine.medicine.companyName,
            alertQuantity: finalMedicine.medicine.alertQuantity,
            description: finalMedicine.medicine.description,
            imagePath: finalMedicine.medicine.imagePath,
          ),
        );
        await scannedBox.put(id, newScannedMedicine);
      }

      // Check if the quantity in FinalMedicine is zero and remove it if necessary
      if (finalMedicine.medicine.quantity <= 0) {
        await finalBox.delete(id);
      }
    }
  }

  Future<void> decreaseQuantity(String id, int quantity) async {
    final scannedBox = await _openScannedBox();
    FinalMedicine? scannedMedicine = scannedBox.get(id);

    if (scannedMedicine != null &&
        scannedMedicine.medicine.quantity >= quantity) {
      scannedMedicine.medicine.quantity -= quantity;
      await scannedBox.put(id, scannedMedicine);
    } else {
      throw Exception('Not enough quantity to decrease');
    }
  }

  Future<void> updateScannedMedicine(FinalMedicine scannedMedicine) async {
    final scannedBox = await _openScannedBox();
    await scannedBox.put(scannedMedicine.id, scannedMedicine);
  }

  Future<void> deleteScannedMedicine(String id) async {
    final scannedBox = await _openScannedBox();
    await scannedBox.delete(id);
  }

  Future<List<FinalMedicine>> getAllScannedMedicines() async {
    final scannedBox = await _openScannedBox();
    return scannedBox.values.toList();
  }

  Future<void> printAllScannedMedicines() async {
    final scannedBox = await _openScannedBox();
    scannedBox.values.forEach((medicine) {
      print(
          'ID: ${medicine.id}, Product Name: ${medicine.medicine.productName}, Quantity: ${medicine.medicine.quantity}');
    });
  }
}
