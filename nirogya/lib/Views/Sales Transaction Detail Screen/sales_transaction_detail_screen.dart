import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../Model/Sales Bill/sales_bill.dart';
import '../../Utils/mobilePdfDownloader.dart';
import '../../Utils/sales_bill_pdf.dart';
import '../../Utils/webPdfDownloader.dart'; // Import the SalesBill model

class SalesTransactionDetailsScreen extends StatelessWidget {
  final SalesBill salesBill; // Accept the SalesBill object

  const SalesTransactionDetailsScreen({Key? key, required this.salesBill})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate the total amount
    double totalAmount = salesBill.medicines.fold(
      0.0,
      (sum, medicine) => sum + (medicine.price * medicine.quantity),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Sales Transaction Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Customer Details and Transaction ID
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      salesBill.customerName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      salesBill.customerContactNumber,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                Text(
                  "#${salesBill.invoiceNumber}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Detailed Medicine List
            Expanded(
              child: ListView.builder(
                itemCount: salesBill.medicines.length,
                itemBuilder: (context, index) {
                  final medicine = salesBill.medicines[index];
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // First Column: Price and Quantity
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Price: ₹${medicine.price.toStringAsFixed(2)}",
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
                              // Second Column: Batch and Expiry
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
              ),
            ),

            // Payment Details
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Payment Mode",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      salesBill.paymentMethod,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Total Amount",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "₹${totalAmount.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Buttons for Download and Share
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      // Implement download functionality
                      final pdfBytes =
                          await SalesBillPdfUtils.generateSalesBillPdf(
                              invoiceNumber: salesBill
                                  .invoiceNumber // Pass the salesBill object
                              );

                      if (kIsWeb) {
                        WebPdfDownloader.webpdfDownload(pdfBytes, true);
                      } else {
                        MobilePdfDownloader.mobilePdfDownload(pdfBytes, true);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Share",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      // Implement share functionality
                      final pdfBytes =
                          await SalesBillPdfUtils.generateSalesBillPdf(
                              invoiceNumber: salesBill
                                  .invoiceNumber // Pass the salesBill object
                              );

                      if (kIsWeb) {
                        WebPdfDownloader.webpdfDownload(pdfBytes, false);
                      } else {
                        MobilePdfDownloader.mobilePdfDownload(pdfBytes, false);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Print",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
