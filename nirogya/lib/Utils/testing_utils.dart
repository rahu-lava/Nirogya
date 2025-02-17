import 'package:nirogya/Data/Sales%20Bill/sales_bill_repo.dart';
import 'package:nirogya/Model/Medicine/medicine.dart';
import 'package:nirogya/Model/Bill/bill.dart';
import '../Data/Bill/bill_repository.dart';
import '../Data/Employee/employee_repo.dart';
import '../Data/Final Medicine History/final_medicine_history_repo.dart';
import '../Data/Final Medicine/final_medicine_repo.dart';
import '../Data/Medicine Queue/medicine_queue_repository.dart';
import '../Model/Final Medicine/final_medicine.dart';
import '../Data/Added Medicine/added_medicine_repo.dart'; // Import the Added Medicine repository

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

  /// Prints details of all final medicines.
  static Future<void> printAllFinalMedicines() async {
    final FinalMedicineRepository _repository = FinalMedicineRepository();
    List<FinalMedicine> medicines = await _repository.getAllFinalMedicines();
    if (medicines.isEmpty) {
      print("No medicines found.");
    } else {
      for (var medicine in medicines) {
        print(
            "ID:  ${medicine.id}, Name: ${medicine.medicine.productName}, Quantity: ${medicine.medicine.quantity}, Expiry Date: ${medicine.medicine.expiryDate}");
      }
    }
  }

  /// Prints details of all final medicine history.
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

  /// Prints details of all added medicines.
  static Future<void> printAllAddedMedicines() async {
    final addedMedicineRepo = AddedMedicineRepository();
    final addedMedicines = await addedMedicineRepo.getAllAddedMedicines();

    if (addedMedicines.isEmpty) {
      print('No added medicines available.');
    } else {
      print('===== Added Medicines =====');
      for (var medicine in addedMedicines) {
        print('ID: ${medicine.finalMedicine.id}');
        print('Product Name: ${medicine.finalMedicine.medicine.productName}');
        print('Price: ${medicine.finalMedicine.medicine.price}');
        print('Quantity: ${medicine.finalMedicine.medicine.quantity}');
        print('Expiry Date: ${medicine.finalMedicine.medicine.expiryDate}');
        print('Batch: ${medicine.finalMedicine.medicine.batch}');
        print('Dealer Name: ${medicine.finalMedicine.medicine.dealerName}');
        print('GST: ${medicine.finalMedicine.medicine.gst}');
        print(
            'Company Name: ${medicine.finalMedicine.medicine.companyName ?? "N/A"}');
        print(
            'Alert Quantity: ${medicine.finalMedicine.medicine.alertQuantity ?? "N/A"}');
        print(
            'Description: ${medicine.finalMedicine.medicine.description ?? "N/A"}');
        print(
            'Image Path: ${medicine.finalMedicine.medicine.imagePath ?? "N/A"}');
        print('Scanned Barcodes: ${medicine.scannedBarcodes}');
        print('----------------------------');
      }
      print('===============================');
    }
  }

  static Future<void> printAllSalesBills() async {
    final salesBills = await SalesBillRepository.getAllSalesBills();

    if (salesBills.isEmpty) {
      print("No sales bills available.");
    } else {
      print("===== Sales Bills =====");
      for (var bill in salesBills) {
        print("Invoice Number: ${bill.invoiceNumber}");
        print("Date: ${bill.date}");
        print("Customer Name: ${bill.customerName}");
        print("Customer Contact: ${bill.customerContactNumber}");
        print("Payment Method: ${bill.paymentMethod}");
        print("Medicines:");

        // Print details of each medicine in the bill
        for (var medicine in bill.medicines) {
          print(
              "  - Name: ${medicine.productName}, Price: ${medicine.price}, Quantity: ${medicine.quantity}, Expiry: ${medicine.expiryDate}, Batch: ${medicine.batch}, Dealer: ${medicine.dealerName}, Company: ${medicine.companyName}, GST: ${medicine.gst}, Alert Quantity: ${medicine.alertQuantity}, Description: ${medicine.description}, Image: ${medicine.imagePath}");
        }

        // Calculate and print the total amount
        double totalAmount = bill.medicines.fold(
          0.0,
          (sum, medicine) => sum + (medicine.price * medicine.quantity),
        );
        print("Total Amount: ₹${totalAmount.toStringAsFixed(2)}");
        print("----------------------------");
      }
      print("===============================");
    }
  }

  /// Prints details of all employees.
  static Future<void> printAllEmployees() async {
    final employeeRepository = EmployeeRepository();
    final employees = await employeeRepository.getAllEmployees();

    if (employees.isEmpty) {
      print("No employees found.");
    } else {
      print("===== Employee List =====");
      for (var employee in employees) {
        print("ID: ${employee.id}");
        print("Name: ${employee.name}");
        print("Contact: ${employee.contact}");
        print("Profile Image: ${employee.profileImage}");
        print("Date of Joining: ${employee.dateOfJoining}");
        print("Attendance Records:");

        // Print attendance records
        for (var attendance in employee.attendance) {
          print(
              "  - Date: ${attendance.date}, Time In: ${attendance.timeIn}, Time Out: ${attendance.timeOut}");
        }

        print("----------------------------");
      }
      print("===============================");
    }
  }
}
