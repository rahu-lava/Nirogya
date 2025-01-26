import 'package:nirogya/Model/Medicine/medicine.dart';

class TestingUtils {
  /// Prints details of a single Medicine object.
  static void printMedicine(Medicine medicine) {
    print("Medicine Details:");
    print("Name: ${medicine.productName}");
    print("Price: ${medicine.price}");
    print("Quantity: ${medicine.quantity}");
    print("Expiry Date: ${medicine.expiryDate}");
    print("Batch: ${medicine.batch}");
    print("Dealer: ${medicine.dealerName}");
    print("Company: ${medicine.companyName}");
    print("Alert Quantity: ${medicine.alertQuantity}");
    print("Description: ${medicine.description}");
    print("Image Path: ${medicine.imagePath}");
  }

  /// Prints details of all medicines in the list.
  static void printAllMedicines(List<Medicine> medicines) {
    if (medicines.isEmpty) {
      print("No medicines added yet.");
    } else {
      print("List of Medicines:");
      for (var medicine in medicines) {
        print(
            "Name: ${medicine.productName}, Price: ${medicine.price}, Quantity: ${medicine.quantity}, Expiry: ${medicine.expiryDate}, Batch: ${medicine.batch}, Dealer: ${medicine.dealerName}, Company: ${medicine.companyName}, AlertQuantity: ${medicine.alertQuantity}, Description: ${medicine.description} , Image: ${medicine.imagePath}");
      }
    }
  }
}
