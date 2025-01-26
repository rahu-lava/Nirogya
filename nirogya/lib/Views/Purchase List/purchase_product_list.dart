import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nirogya/Utils/permission_handler.dart';
import 'package:nirogya/Utils/testing_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:nirogya/View%20Model/Purchase%20List/purchase_list_view_model.dart';
import 'package:nirogya/Views/Add%20Purchase%20Screen/purchase_bill_add_product.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toast_service.dart';

import '../../Utils/bill_utils.dart';

class PurchaseProductList extends StatelessWidget {
  final purchaseListViewModel = PurchaseListViewModel();

  @override
  Widget build(BuildContext context) {
    // await purchaseListViewModel.fetchMedicineQueue();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Purchase Products"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancel",
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Add Manually Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PurchaseBillPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff920000),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Add More",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                // Medicine List (Scrollable)

                Expanded(
                  child: Consumer<PurchaseListViewModel>(
                    builder: (context, viewModel, child) {
                      TestingUtils.printAllMedicines(viewModel.medicineQueue);
                      if (viewModel.medicineQueue.isEmpty) {
                        return const Center(
                          child: Text("No medicines in the queue."),
                        );
                      }
                      return ListView.builder(
                        itemCount: viewModel.medicineQueue.length,
                        itemBuilder: (context, index) {
                          final medicine = viewModel.medicineQueue[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Medicine Name
                                  Text(
                                    medicine.productName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  // Details (Row with 2 Columns)
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // First Column: Price and Quantity
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Price: ${medicine.price}",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            "Quantity: ${medicine.quantity}",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 20),
                                      // Second Column: Batch and Expiry
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Batch: ${medicine.batch}",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            "Expiry: ${medicine.expiryDate}",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 70), // Space below before sticky buttons
              ],
            ),
          ),
          // Sticky Button at the Bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Proceed Button
                  ElevatedButton(
                    onPressed: () {
                      // Add action for "Proceed"
                      ToastService.showSuccessToast(context,
                          length: ToastLength.medium,
                          message: "Products added in the queue");

                      _showDailog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Proceed",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _showDailog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Select Option",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Poppins",
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      // WhatsApp action here
                    },
                    child: Container(
                      width: 120, // Fixed width for both containers
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xff920000),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/whatsapp_white.png',
                            height: 50,
                            width: 50,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Whatsapp",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontFamily: "Poppins",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      // Request permissions before printing
                      PermissionStatus status = await Permission.storage.status;

                      if (status.isGranted) {
                        // Permission granted, proceed with printing
                        final billItems = [
                          {'name': 'Item 1', 'quantity': 2, 'price': 10.0},
                          {'name': 'Item 2', 'quantity': 1, 'price': 15.0},
                        ];
                        await generateBillPdf(context, billItems, false);
                      } else {
                        // Permission denied, show a message
                        ToastService.showErrorToast(context,
                            length: ToastLength.medium,
                            message: "Permission to print is required.");
                      }

                      Navigator.of(context).pop();
                      PermissionHandlerUtil.requestPermissions(context);
                    },
                    child: Container(
                      width: 120, // Fixed width for both containers
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xff920000),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/printer.png',
                            height: 50,
                            width: 50,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Print",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontFamily: "Poppins",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

// Future<String> generateBillPdfs(
//     BuildContext context, List<Map<String, dynamic>> items) async {
//   final String pdfFile = await generateBillPdf(context, items );
//   return pdfFile;
// }