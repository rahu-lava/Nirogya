import 'package:hive/hive.dart';
import '../../Model/Bill/bill.dart';

class BillRepository {
  static const String _boxName = 'bills';

  // Open the Hive box
  static Future<Box<Bill>> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<Bill>(_boxName);
    }
    return Hive.box<Bill>(_boxName);
  }

  // Save a bill
  static Future<void> saveBill(Bill bill) async {
    try {
      final box = await _getBox();
      await box.put(bill.invoiceNumber, bill);
    } catch (e) {
      throw Exception("Failed to save bill: $e");
    }
  }

  // Get a specific bill by invoice number
  static Future<Bill?> getBillByInvoiceNumber(String invoiceNumber) async {
    try {
      final box = await _getBox();
      return box.get(invoiceNumber);
    } catch (e) {
      throw Exception("Failed to fetch bill by invoice number: $e");
    }
  }

  // Get all bills
  static Future<List<Bill>> getAllBills() async {
    try {
      final box = await _getBox();
      return box.values.toList();
    } catch (e) {
      throw Exception("Failed to fetch all bills: $e");
    }
  }

  // Delete a bill by invoice number
  static Future<void> deleteBill(String invoiceNumber) async {
    try {
      final box = await _getBox();
      await box.delete(invoiceNumber);
    } catch (e) {
      throw Exception("Failed to delete bill: $e");
    }
  }

  // Clear all bills
  static Future<void> clearAllBills() async {
    try {
      final box = await _getBox();
      await box.clear();
    } catch (e) {
      throw Exception("Failed to clear all bills: $e");
    }
  }

  // Get a specific bill by transaction ID (if needed)
  static Future<Bill?> getBillByTransactionId(String transactionId) async {
    try {
      final box = await _getBox();
      return box.values.firstWhere(
        (bill) => bill.invoiceNumber == transactionId,
      );
    } catch (e) {
      throw Exception("Failed to fetch bill by transaction ID: $e");
    }
  }
}
