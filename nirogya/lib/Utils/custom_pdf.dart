import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:nirogya/Model/Medicine/medicine.dart';
import 'package:nirogya/Model/Bill/bill.dart';

import 'package:nirogya/Utils/testing_utils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../Data/Bill/bill_repository.dart';
import '../Data/User/user_repository.dart';
import '../View Model/Add Purchase/add_purchase_view_model.dart';
import 'mobilePdfDownloader.dart';
import 'webPdfDownloader.dart';

Future<void> generatePurchaseBillPdfBytes(bool isShare) async {
  // Fetch dealer details
  final dealer = await PurchaseViewModel.getDealerDetails();
  if (dealer == null) {
    throw Exception("Dealer not selected or doesn't exist!");
  }

  // Fetch current user details
  final userRepository = UserRepository();
  final currentUser = await userRepository.getUser();
  if (currentUser == null) {
    throw Exception("User details not found!");
  }

  // Generate a random invoice number starting with "NIR"
  String generateInvoiceNumber() {
    final random = Random();
    final uniqueNumber = random.nextInt(99999).toString().padLeft(5, '0');
    return "NIR$uniqueNumber";
  }

  final invoiceNumber = generateInvoiceNumber();

  // Get medicines
  final List<Medicine> medicines = PurchaseViewModel.billMedicines;
  if (medicines.isEmpty) {
    throw Exception("No medicines available for the bill!");
  }

  // Save bill using BillRepository
  final bill = Bill(
    invoiceNumber: invoiceNumber,
    date: DateTime.now(),
    medicines: medicines,
    dealerName: dealer.name,
    dealerContact: dealer.contactNumber ?? "N/A",
    gstNumber: dealer.gstin ?? "N/A",
  );

  // final billRepository = BillRepository();
  await BillRepository.saveBill(bill);

  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(20),
      build: (context) {
        // Total calculation
        double totalAmount = 0;
        double totalCGST = 0;
        double totalSGST = 0;

        final medicineData = medicines.map((medicine) {
          double itemTotal = medicine.price * medicine.quantity;
          double gstAmount = (itemTotal * medicine.gst) / 100;
          double cgst = gstAmount / 2;
          double sgst = gstAmount / 2;

          totalAmount += itemTotal;
          totalCGST += cgst;
          totalSGST += sgst;

          return [
            medicine.productName,
            medicine.batch,
            medicine.expiryDate,
            '\$${medicine.price.toStringAsFixed(2)}',
            medicine.quantity,
            '${medicine.gst}%',
            '\$${itemTotal.toStringAsFixed(2)}',
          ];
        }).toList();

        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Title
            pw.Center(
              child: pw.Text(
                "Nirogya",
                style: pw.TextStyle(
                  fontSize: 28,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.red900,
                ),
              ),
            ),
            pw.SizedBox(height: 20),

            // Dealer & Shop Details
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("Dealer Details:",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text("Name: ${dealer.name}"),
                    pw.Text("GSTIN: ${dealer.gstin ?? "N/A"}"),
                    pw.Text("Contact: ${dealer.contactNumber ?? "N/A"}"),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("Shop Details:",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text("Name: ${currentUser.shopName ?? "N/A"}"),
                    pw.Text("GSTIN: ${currentUser.gstin ?? "N/A"}"),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 20),

            // Invoice Details
            pw.Text(
              "Invoice No: $invoiceNumber",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text("Date: ${DateTime.now().toString().split(' ')[0]}"),
            pw.SizedBox(height: 20),

            // Product Table
            pw.Table.fromTextArray(
              headers: [
                'Product Name',
                'Batch',
                'Expiry Date',
                'Price/Unit',
                'Quantity',
                'GST',
                'Total',
              ],
              data: medicineData,
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
              headerDecoration: pw.BoxDecoration(
                color: PdfColors.red900,
              ),
              cellHeight: 25,
              cellAlignment: pw.Alignment.centerLeft,
              border: pw.TableBorder.all(color: PdfColors.grey),
            ),
            pw.SizedBox(height: 20),

            // Total Section
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      'Subtotal: \$${totalAmount.toStringAsFixed(2)}',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      'CGST: \$${totalCGST.toStringAsFixed(2)}',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      'SGST: \$${totalSGST.toStringAsFixed(2)}',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Divider(),
                    pw.Text(
                      'Total Amount: \$${(totalAmount + totalCGST + totalSGST).toStringAsFixed(2)}',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 16,
                        color: PdfColors.red900,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    ),
  );

  // Save and handle the PDF based on the platform.
  List<int> bytes = await pdf.save();

  if (kIsWeb) {
    WebPdfDownloader.webpdfDownload(bytes, isShare);
  } else {
    MobilePdfDownloader.mobilePdfDownload(bytes, isShare);
  }
}
