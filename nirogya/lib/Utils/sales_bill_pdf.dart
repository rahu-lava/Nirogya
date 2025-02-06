import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:nirogya/Model/Medicine/medicine.dart';
import 'package:nirogya/Model/Sales Bill/sales_bill.dart';
import 'package:nirogya/Data/User/user_repository.dart';
import 'mobilePdfDownloader.dart';
import 'webPdfDownloader.dart';

class SalesBillPdfUtils {
  // Generate a random invoice number starting with "NIR" followed by 5 alphanumeric characters
  static String generateInvoiceNumber() {
    const chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    final random = Random();
    final uniqueNumber = List.generate(5, (index) => chars[random.nextInt(chars.length)]).join();
    return "NIR$uniqueNumber";
  }

  // Generate the PDF and return the bytes
  static Future<Uint8List> generateSalesBillPdf({
    required List<Map<String, dynamic>> scannedItems,
    required String customerName,
    required String customerContactNumber,
    required String paymentMethod,
  }) async {
    // Fetch current user details
    final userRepository = UserRepository();
    final currentUser = await userRepository.getUser();
    if (currentUser == null) {
      throw Exception("User details not found!");
    }

    // Convert scanned items to Medicine objects
    final List<Medicine> medicines = scannedItems.map((item) {
      return Medicine(
        productName: item['name'],
        price: item['price'],
        quantity: item['quantity'],
        expiryDate: item['expiryDate'] ?? '',
        batch: item['batch'] ?? '',
        dealerName: item['dealerName'] ?? '',
        gst: item['gst'] ?? 0,
        companyName: item['companyName'] ?? '',
        alertQuantity: item['alertQuantity'] ?? 0,
        description: item['description'] ?? '',
        imagePath: item['imagePath'] ?? '',
      );
    }).toList();

    // Generate the PDF
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

              // Customer & Shop Details
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("Customer Details:",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text("Name: $customerName"),
                      pw.Text("Contact: $customerContactNumber"),
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
                "Invoice No: ${generateInvoiceNumber()}",
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

    return pdf.save();
  }
}