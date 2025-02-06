import 'package:hive/hive.dart';
import '../../Model/Sales Bill/sales_bill.dart';

class SalesBillRepository {
  static const String _boxName =
      'salesBills'; // Unique box name for sales bills

  // Open the Hive box
  static Future<Box<SalesBill>> _getBox() async {
    return await Hive.openBox<SalesBill>(_boxName);
  }

  // Get a specific sales bill by transaction ID
  static Future<SalesBill?> getSalesBillByTransactionId(
      String transactionId) async {
    final box = await _getBox();
    return box.values.firstWhere(
      (salesBill) => salesBill.invoiceNumber == transactionId,
    );
  }

  // Save a sales bill
  static Future<void> saveSalesBill(SalesBill salesBill) async {
    final box = await _getBox();
    await box.put(salesBill.invoiceNumber, salesBill);
  }

  // Get all sales bills
  static Future<List<SalesBill>> getAllSalesBills() async {
    final box = await _getBox();
    return box.values.toList();
  }

  // Get a specific sales bill by invoice number
  static Future<SalesBill?> getSalesBillByInvoice(String invoiceNumber) async {
    final box = await _getBox();
    return box.get(invoiceNumber);
  }

  // Delete a sales bill
  static Future<void> deleteSalesBill(String invoiceNumber) async {
    final box = await _getBox();
    await box.delete(invoiceNumber);
  }

  // Clear all sales bills
  static Future<void> clearAllSalesBills() async {
    final box = await _getBox();
    await box.clear();
  }
}
