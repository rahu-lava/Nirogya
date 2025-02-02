import 'package:flutter/material.dart';
import 'package:nirogya/Utils/testing_utils.dart';
import 'package:nirogya/View%20Model/Medicine/medicine_view_model.dart';
import 'package:nirogya/Views/Add%20Purchase%20Screen/purchase_bill_add_product.dart';
import 'package:provider/provider.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toast_service.dart';

import '../../Data/Dealer/dealer_repository.dart';
import '../../Data/Medicine Queue/medicine_queue_repository.dart';
import '../../Model/Dealer/dealer.dart';
import '../../Model/Medicine/medicine.dart';
import '../../Views/Purchase List/purchase_product_list.dart';
import '../Purchase List/purchase_list_view_model.dart';

class PurchaseViewModel extends ChangeNotifier {
  static List<Medicine> _temp_medicines = [];
  static List<Medicine> _bill_medicines = [];
  static String? _currentDealer;

  static List<Medicine> get tempMedicines => _temp_medicines;
  static List<Medicine> get billMedicines => _bill_medicines;
  static String? get currentDealer => _currentDealer;

  void saveTempMeds(Medicine medicine) {
    _temp_medicines.add(medicine);
    // print("addingmedicine in temp");
    TestingUtils.printAllMedicines(_temp_medicines);
    notifyListeners();
  }

  static void setCurrentDealer({required String currentDealer}) {
    _currentDealer = currentDealer;
  }

  Future<void> saveTempProduct({
    required BuildContext context,
    required String productName,
    required String price,
    required String quantity,
    required String batch,
    required String? expiryDate,
    required String? dealerName,
    required String gst,
    String imagePath = "",
    String companyName = "",
    String alertQuantity = "",
    String description = "",
  }) async {
    // print("me yeha hun");
    // Validation
    if (productName.trim().isEmpty) {
      _showErrorToast(context, "Please enter the Product name.");
      return;
    }
    if (price.trim().isEmpty) {
      _showErrorToast(context, "Please enter the Price.");
      return;
    }
    if (quantity.trim().isEmpty) {
      _showErrorToast(context, "Please enter the Quantity.");
      return;
    }
    if (batch.trim().isEmpty) {
      _showErrorToast(context, "Please enter the Batch.");
      return;
    }
    if (expiryDate == null) {
      _showErrorToast(context, "Please select the Expiry Date.");
      return;
    }
    if (dealerName == null) {
      _showErrorToast(context, "Please select the Dealer.");
      return;
    }
    if (gst.trim().isEmpty) {
      _showErrorToast(context, "Please enter the GST Percentage");
      return;
    }

    // Create a `Medicine` object (or handle saving logic here)
    final medicine = Medicine(
      productName: productName.trim(),
      price: double.tryParse(price.trim()) ?? 0.0,
      quantity: int.tryParse(quantity.trim()) ?? 0,
      expiryDate: expiryDate,
      batch: batch.trim(),
      dealerName: dealerName,
      gst: int.tryParse(gst.trim()) ?? 0,
      imagePath: imagePath,
      companyName: companyName.trim().isNotEmpty ? companyName.trim() : "-",
      alertQuantity: alertQuantity.trim().isNotEmpty
          ? int.tryParse(alertQuantity.trim()) ?? 0
          : 0,
      description: description.trim().isNotEmpty ? description.trim() : "-",
    );

    saveTempMeds(medicine);

    // Navigate to another screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (_) => PurchaseListViewModel()..fetchMedicineQueue(),
          child: PurchaseProductList(),
        ),
      ),
    );
  }

  void clearProduct() {
    _temp_medicines.clear();
    notifyListeners();
  }

  Future<void> transferProductToQueue() async {
    final medicineQueueRepo = MedicineQueueRepository();
    for (var medicine in _temp_medicines) {
      await medicineQueueRepo.addMedicineToQueue(medicine);
    }
    _bill_medicines = List.from(_temp_medicines);
    print("bill meds");
    TestingUtils.printAllMedicines(_bill_medicines);
    clearProduct();
    notifyListeners();
  }

  void _showErrorToast(BuildContext context, String message) {
    FocusScope.of(context).unfocus();
    ToastService.showErrorToast(context,
        length: ToastLength.medium, message: message);
  }

  static Future<Dealer?> getDealerDetails() async {
    if (_currentDealer == null) return null;
    final dealerRepo = DealerRepository();
    final allDealers = await dealerRepo.getAllDealers();
    return allDealers.firstWhere((dealer) => dealer.name == _currentDealer);
  }

  void updateBillMeds() {}
}
