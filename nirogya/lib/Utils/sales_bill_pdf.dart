import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/services.dart'; // For loading assets
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:nirogya/Data/User/user_repository.dart';
import 'package:nirogya/Data/Sales Bill/sales_bill_repo.dart'; // Import the SalesBill repository

class SalesBillPdfUtils {
  static String generateInvoiceNumber() {
    const chars = '0123456789';
    final random = Random();
    final uniqueNumber =
        List.generate(5, (index) => chars[random.nextInt(chars.length)]).join();
    return "NIR$uniqueNumber";
  }

  // Generate the PDF and return the bytes
  static Future<Uint8List> generateSalesBillPdf({
    required String invoiceNumber, // Accept invoice number as an argument
  }) async {
    // Fetch the sales bill by invoice number
    final salesBill =
        await SalesBillRepository.getSalesBillByInvoice(invoiceNumber);
    if (salesBill == null) {
      throw Exception(
          "Sales bill not found for invoice number: $invoiceNumber");
    }

    // Fetch current user details
    final userRepository = UserRepository();
    final currentUser = await userRepository.getUser();
    if (currentUser == null) {
      throw Exception("User details not found!");
    }

    // Load the logo image from assets
    final ByteData logoData =
        await rootBundle.load('assets/images/nirogya_logo_short.png');
    final Uint8List logoBytes = logoData.buffer.asUint8List();

    // Generate the PDF
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (context) {
          // Total calculation
          double totalAmount = salesBill.medicines.fold(
            0.0,
            (sum, medicine) => sum + (medicine.price * medicine.quantity),
          );

          final medicineData = salesBill.medicines.map((medicine) {
            double itemTotal = medicine.price * medicine.quantity;

            return [
              medicine.productName,
              medicine.batch,
              medicine.expiryDate,
              "${medicine.price.toStringAsFixed(2)}",
              medicine.quantity,
              "${itemTotal.toStringAsFixed(2)}",
            ];
          }).toList();

          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Logo Image
              pw.Center(
                child: pw.Image(
                  pw.MemoryImage(logoBytes), // Use the loaded image
                  width: 100, // Adjust the width as needed
                  height: 100, // Adjust the height as needed
                ),
              ),
              pw.SizedBox(height: 20),

              // Customer & Shop Details
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("Customer Details:",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text("Name: ${salesBill.customerName}"),
                      pw.Text("Contact: ${salesBill.customerContactNumber}"),
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
                "Invoice No: ${salesBill.invoiceNumber}",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text("Date: ${salesBill.date.toString().split(' ')[0]}"),
              pw.SizedBox(height: 20),

              // Product Table
              pw.Table.fromTextArray(
                headers: [
                  'Product Name',
                  'Batch',
                  'Expiry Date',
                  'Price/Unit',
                  'Quantity',
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
                        "Total Amount: Rs${totalAmount.toStringAsFixed(2)}",
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

    return pdf.save();
  }
}
