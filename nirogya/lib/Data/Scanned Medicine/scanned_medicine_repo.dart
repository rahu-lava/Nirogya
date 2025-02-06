import 'package:bottom_bar_matu/utils/app_utils.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:nirogya/Utils/testing_utils.dart';
import '../../Model/Final Medicine/final_medicine.dart';
import '../../Model/Medicine/medicine.dart';
import '../../Model/Scanned Medicine/scanned_medicine.dart';
import '../../Data/Added Medicine/added_medicine_repo.dart'; // Import the Added Medicine repository

class ScannedMedicineRepository {
  static const String _scannedBoxName = 'scanned_medicines';
  static const String _finalBoxName = 'final_medicines';

  final AddedMedicineRepository _addedMedicineRepo =
      AddedMedicineRepository(); // Added Medicine repository

  Future<Box<ScannedMedicine>> _openScannedBox() async {
    return await Hive.openBox<ScannedMedicine>(_scannedBoxName);
  }

  Future<Box<FinalMedicine>> _openFinalBox() async {
    return await Hive.openBox<FinalMedicine>(_finalBoxName);
  }

  void _showToast(BuildContext context, String message,
      {bool isError = false}) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<bool> addScannedMedicine(String barcode, BuildContext context) async {
    // Validate the barcode
    if (barcode.length < 5 || !barcode.startsWith('N')) {
      _showToast(context, 'Invalid barcode: $barcode', isError: true);
      return false;
    }

    // Extract the base ID (first 5 characters)
    final String baseId = barcode.substring(0, 5);

    // Open Hive boxes
    final finalBox = await _openFinalBox();
    final scannedBox = await _openScannedBox();

    // Check if the baseId is already present in the Added Medicine repository
    final addedMedicines = await _addedMedicineRepo.getAllAddedMedicines();
    bool isBaseIdAlreadyAdded = addedMedicines.any(
      (medicine) => medicine.finalMedicine.id == baseId,
    );

    // If the baseId is already added, show an error and return
    if (isBaseIdAlreadyAdded) {
      _showToast(context, 'Medicine with base ID $baseId is already added',
          isError: true);
      return false;
    }

    // Find the FinalMedicine object in the finalBox using the base ID
    FinalMedicine? finalMedicine;
    try {
      finalMedicine = finalBox.values.firstWhere(
        (medicine) => medicine.id.startsWith(baseId),
      );
    } catch (_) {
      finalMedicine = null;
    }

    // If no FinalMedicine is found, show an error and return
    if (finalMedicine == null) {
      _showToast(context, 'Medicine not found for barcode: $barcode',
          isError: true);
      return false;
    }

    // Check if the barcode already exists in any ScannedMedicine object
    bool isBarcodeAlreadyScanned = scannedBox.values.any(
      (medicine) => medicine.scannedBarcodes.contains(barcode),
    );

    // If the barcode is already scanned, show an error and return
    if (isBarcodeAlreadyScanned) {
      _showToast(context, 'Barcode $barcode has already been scanned',
          isError: true);
      return false;
    }

    // Find the existing ScannedMedicine object with the same base ID
    ScannedMedicine? existingScannedMedicine;
    try {
      existingScannedMedicine = scannedBox.values.firstWhere(
        (medicine) => medicine.finalMedicine.id == baseId,
      );
    } catch (_) {
      existingScannedMedicine = null;
    }

    // If an existing ScannedMedicine object is found
    if (existingScannedMedicine != null) {
      // Increase the quantity
      existingScannedMedicine.finalMedicine.medicine.quantity += 1;
      // Add the new barcode to the scannedBarcodes list
      existingScannedMedicine.scannedBarcodes.add(barcode);
      // Update the entry in the scannedBox
      await scannedBox.put(baseId, existingScannedMedicine);
      // Show a success message
      _showToast(context, 'Quantity increased for barcode: $barcode',
          isError: false);
    }
    // If no existing ScannedMedicine object is found, create a new one
    else {
      ScannedMedicine newScannedMedicine = ScannedMedicine(
        scannedBarcodes: [barcode], // Add the full barcode to the list
        finalMedicine: FinalMedicine(
          id: baseId, // Use the base ID as the ID for FinalMedicine
          medicine: Medicine(
            productName: finalMedicine.medicine.productName,
            price: finalMedicine.medicine.price,
            quantity: 1, // Set initial quantity to 1
            expiryDate: finalMedicine.medicine.expiryDate,
            batch: finalMedicine.medicine.batch,
            dealerName: finalMedicine.medicine.dealerName,
            gst: finalMedicine.medicine.gst,
            companyName: finalMedicine.medicine.companyName,
            alertQuantity: finalMedicine.medicine.alertQuantity,
            description: finalMedicine.medicine.description,
            imagePath: finalMedicine.medicine.imagePath,
          ),
        ),
      );
      // Save the new entry in the scannedBox
      await scannedBox.put(baseId, newScannedMedicine);
      // Show a success message
      _showToast(context, 'Barcode $barcode added successfully',
          isError: false);
    }

    return true;
  }

  Future<void> decreaseQuantity(String id, int quantity) async {
    final scannedBox = await _openScannedBox();
    ScannedMedicine? scannedMedicine = scannedBox.get(id);

    if (scannedMedicine != null &&
        scannedMedicine.finalMedicine.medicine.quantity >= quantity) {
      scannedMedicine.finalMedicine.medicine.quantity -= quantity;
      await scannedBox.put(id, scannedMedicine);
    } else {
      throw Exception('Not enough quantity to decrease');
    }
  }

  Future<void> updateScannedMedicine(ScannedMedicine scannedMedicine) async {
    final scannedBox = await _openScannedBox();
    await scannedBox.put(scannedMedicine.finalMedicine.id, scannedMedicine);
  }

  Future<void> deleteScannedMedicine(String id) async {
    final scannedBox = await _openScannedBox();
    await scannedBox.delete(id);
  }

  Future<List<ScannedMedicine>> getAllScannedMedicines() async {
    final scannedBox = await _openScannedBox();
    return scannedBox.values.toList();
  }

  Future<void> printAllScannedMedicines() async {
    final scannedBox = await _openScannedBox();
    scannedBox.values.forEach((medicine) {
      print(
          'ID: ${medicine.finalMedicine.id}, Product Name: ${medicine.finalMedicine.medicine.productName}, Quantity: ${medicine.finalMedicine.medicine.quantity}, Scanned Barcodes: ${medicine.scannedBarcodes}');
    });
  }

  Future<void> clearAllScannedMedicines() async {
    final scannedBox = await _openScannedBox();
    await scannedBox.clear();
    print("Deleting all scanned Meds....");
    // TestingUtils.printAllScannedMedicines();
  }
}