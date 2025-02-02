import 'package:nirogya/Model/Medicine/medicine.dart';
import 'package:nirogya/Model/Bill/bill.dart';

import '../Data/Bill/bill_repository.dart';
import '../Data/Final Medicine History/final_medicine_history_repo.dart';
import '../Data/Final Medicine/final_medicine_repo.dart';
import '../Data/Medicine Queue/medicine_queue_repository.dart';
import '../Model/Final Medicine/final_medicine.dart';
// import 'package:nirogya/Repository/Bill/bill_repository.dart';

class TestingUtils {
  /// Prints details of a single Medicine object.
  static void printMedicine(Medicine medicine) {
    print("Medicine Details:");
    print("Name:  ${medicine.productName}");
    print("Price:  ${medicine.price}");
    print("Quantity:  ${medicine.quantity}");
    print("Expiry Date:  ${medicine.expiryDate}");
    print("Batch:  ${medicine.batch}");
    print("Dealer:  ${medicine.dealerName}");
    print("Company:  ${medicine.companyName}");
    print("Alert Quantity:  ${medicine.alertQuantity}");
    print("Description:  ${medicine.description}");
    print("Image Path:  ${medicine.imagePath}");
  }

  /// Prints details of all medicines in the list.
  static void printAllMedicines(List<Medicine> medicines) {
    if (medicines.isEmpty) {
      print("No medicines added yet.");
    } else {
      print("List of Medicines:");
      for (var medicine in medicines) {
        print(
            "Name: ${medicine.productName}, Price: ${medicine.price}, Quantity: ${medicine.quantity}, Expiry: ${medicine.expiryDate}, Batch: ${medicine.batch}, Dealer: ${medicine.dealerName}, Company: ${medicine.companyName}, AlertQuantity: ${medicine.alertQuantity}, Description: ${medicine.description}, Image: ${medicine.imagePath}");
      }
    }
  }

  /// Prints details of a single Bill object.
  static void printBill(Bill bill) {
    print("\nBill Details:");
    print("Invoice Number: ${bill.invoiceNumber}");
    print("Date: ${bill.date}");
    print("Dealer Name: ${bill.dealerName}");
    print("Dealer Contact: ${bill.dealerContact}");
    print("GST Number: ${bill.gstNumber}");
    print("Medicines:");
    printAllMedicines(bill.medicines);
  }

  /// Fetches and prints all bills from the repository.
  static Future<void> printAllBills() async {
    final bills = await BillRepository.getAllBills();
    if (bills.isEmpty) {
      print("No bills available.");
    } else {
      print("\nList of Bills:");
      for (var bill in bills) {
        printBill(bill);
        print("----------------------------");
      }
    }
  }

  /// Prints details of all medicines in the queue.
  static Future<void> printAllMedicinesInQueue() async {
    final medicineQueueRepository = MedicineQueueRepository();
    final medicinesInQueue =
        await medicineQueueRepository.getAllMedicinesInQueue();
    if (medicinesInQueue.isEmpty) {
      print("No medicines in the queue.");
    } else {
      print("Medicines in Queue:");
      for (var medicine in medicinesInQueue) {
        printMedicine(
            medicine); // Use the existing print method to print each medicine
        print("----------------------------");
      }
    }
  }

  static Future<void> printAllFinalMedicines() async {
    final FinalMedicineRepository _repository = FinalMedicineRepository();
    List<FinalMedicine> medicines = await _repository.getAllFinalMedicines();
    if (medicines.isEmpty) {
      print("No medicines found.");
    } else {
      for (var medicine in medicines) {
        print(
            "ID:  ${medicine.id}, Name: ${medicine.medicine.companyName}, Quantity: ${medicine..medicine.quantity}, Expiry Date: ${medicine.medicine.expiryDate}");
      }
    }
  }

  static Future<void> printAllHistory() async {
    final historyRepo = FinalMedicineHistoryRepository();
    final history = await historyRepo.getAllFinalMedicineHistory();

    if (history.isEmpty) {
      print('No history data available.');
      return;
    }

    print('===== Final Medicine History =====');
    for (var entry in history) {
      final timestamp = entry.keys.first;
      final finalMedicine = entry.values.first;

      print('Timestamp: $timestamp');
      print('ID: ${finalMedicine.id}');
      print('Product Name: ${finalMedicine.medicine.productName}');
      print('Price: ${finalMedicine.medicine.price}');
      print('Quantity: ${finalMedicine.medicine.quantity}');
      print('Expiry Date: ${finalMedicine.medicine.expiryDate}');
      print('Batch: ${finalMedicine.medicine.batch}');
      print('Dealer Name: ${finalMedicine.medicine.dealerName}');
      print('GST: ${finalMedicine.medicine.gst}');
      print('Company Name: ${finalMedicine.medicine.companyName ?? "N/A"}');
      print('Alert Quantity: ${finalMedicine.medicine.alertQuantity ?? "N/A"}');
      print('Description: ${finalMedicine.medicine.description ?? "N/A"}');
      print('Image Path: ${finalMedicine.medicine.imagePath ?? "N/A"}');
      print('----------------------------------');
    }
    print('==================================');
  }
}
