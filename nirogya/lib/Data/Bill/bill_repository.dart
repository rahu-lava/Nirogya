import 'package:hive/hive.dart';
import '../../Model/Bill/bill.dart';

class BillRepository {
  static const String _boxName = 'bills';

  // Open the Hive box
  static Future<Box<Bill>> _getBox() async {
    return await Hive.openBox<Bill>(_boxName);
  }

  // Get a specific bill by transaction ID
  static Future<Bill?> getBillByTransactionId(String transactionId) async {
    final box = await _getBox();
    return box.values.firstWhere(
      (bill) => bill.invoiceNumber == transactionId,
    );
  }

  // Save a bill
  static Future<void> saveBill(Bill bill) async {
    final box = await _getBox();
    await box.put(bill.invoiceNumber, bill);
  }

  // Get all bills
  static Future<List<Bill>> getAllBills() async {
    final box = await _getBox();
    return box.values.toList();
  }

  // Get a specific bill by invoice number
  static Future<Bill?> getBillByInvoice(String invoiceNumber) async {
    final box = await _getBox();
    return box.get(invoiceNumber);
  }

  // Delete a bill
  static Future<void> deleteBill(String invoiceNumber) async {
    final box = await _getBox();
    await box.delete(invoiceNumber);
  }

  // Clear all bills
  static Future<void> clearAllBills() async {
    final box = await _getBox();
    await box.clear();
  }
}
