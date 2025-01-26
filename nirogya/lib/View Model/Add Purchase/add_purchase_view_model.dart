import 'package:flutter/material.dart';
import 'package:nirogya/Utils/testing_utils.dart';
import 'package:provider/provider.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toast_service.dart';

import '../../Data/Medicine Queue/medicine_queue_repository.dart';
import '../../Model/Medicine/medicine.dart';
import '../../Views/Purchase List/purchase_product_list.dart';
import '../Purchase List/purchase_list_view_model.dart';

class PurchaseViewModel extends ChangeNotifier {
  Future<void> saveProduct({
    required BuildContext context,
    required String productName,
    required String price,
    required String quantity,
    required String batch,
    required String? expiryDate,
    required String? dealerName,
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

    // Create a `Medicine` object (or handle saving logic here)
    final medicine = Medicine(
      productName: productName.trim(),
      price: double.tryParse(price.trim()) ?? 0.0,
      quantity: int.tryParse(quantity.trim()) ?? 0,
      expiryDate: expiryDate,
      batch: batch.trim(),
      dealerName: dealerName,
      imagePath: imagePath,
      companyName: companyName.trim().isNotEmpty ? companyName.trim() : "-",
      alertQuantity: alertQuantity.trim().isNotEmpty
          ? int.tryParse(alertQuantity.trim()) ?? 0
          : 0,
      description: description.trim().isNotEmpty ? description.trim() : "-",
    );
    print(medicine);

    TestingUtils.printMedicine(medicine);
    final medicineQueueRepo = MedicineQueueRepository();
    await medicineQueueRepo.addMedicineToQueue(medicine);
    TestingUtils.printAllMedicines(
        await medicineQueueRepo.getAllMedicinesInQueue());
    // Save the medicine or update the list
    // For example:
    // medicineList.add(medicine);
    // notifyListeners();

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

  void _showErrorToast(BuildContext context, String message) {
    FocusScope.of(context).unfocus();
    ToastService.showErrorToast(context,
        length: ToastLength.medium, message: message);
  }
}
