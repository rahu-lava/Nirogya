// import 'package:flutter/foundation.dart'; // For kIsWeb.
// import 'package:flutter/material.dart';
// import 'package:nirogya/Utils/mobilePdfDownloader.dart';
// import 'package:nirogya/Utils/webPdfDownloader.dart';
// import 'package:syncfusion_flutter_pdf/pdf.dart';
// import 'dart:typed_data';
// import 'dart:ui';

// Future<void> generatePurchaseBillPdf(BuildContext context,
//     List<Map<String, dynamic>> items, bool isShare) async {
//   // Create a PDF document.
//   final PdfDocument document = PdfDocument();

//   // Add a page to the document.
//   final PdfPage page = document.pages.add();

//   // Get the graphics for the page.
//   final PdfGraphics graphics = page.graphics;

//   // Add Nirogya logo at the top center.
//   const String logoText = "Nirogya";
//   graphics.drawString(
//     logoText,
//     PdfStandardFont(PdfFontFamily.helvetica, 25, style: PdfFontStyle.bold),
//     brush: PdfSolidBrush(PdfColor(0, 0, 0)),
//     bounds: const Rect.fromLTWH(200, 10, 300, 40),
//     format: PdfStringFormat(alignment: PdfTextAlignment.center),
//   );

//   // Draw seller and buyer details.
//   graphics.drawString(
//     'Dealer Details:\nName: Dealer XYZ\nGSTIN: 27XXXXXXXXXXZ5\nContact: +91XXXXXXXXXX',
//     PdfStandardFont(PdfFontFamily.helvetica, 12),
//     bounds: const Rect.fromLTWH(10, 60, 250, 80),
//   );

//   graphics.drawString(
//     'Shop Details:\nName: Buyer ABC\nGSTIN: 27XXXXXXXXXXZ5',
//     PdfStandardFont(PdfFontFamily.helvetica, 12),
//     bounds: const Rect.fromLTWH(300, 60, 250, 80),
//   );

//   // Add invoice details.
//   graphics.drawString(
//     'Invoice No: INV12345\nDate: ${DateTime.now().toString().split(' ')[0]}',
//     PdfStandardFont(PdfFontFamily.helvetica, 12),
//     bounds: const Rect.fromLTWH(10, 140, 500, 20),
//   );

//   // Create the product table.
//   final PdfGrid table = PdfGrid();
//   table.columns.add(count: 6);

//   // Add header row with dark red background and white text.
//   final PdfGridRow header = table.headers.add(1)[0];
//   header.style.backgroundBrush = PdfSolidBrush(PdfColor(146, 0, 0));
//   header.style.textBrush = PdfBrushes.white;
//   header.cells[0].value = 'Product Name';
//   header.cells[1].value = 'Price/Unit';
//   header.cells[2].value = 'Quantity';
//   header.cells[3].value = 'GST %';
//   header.cells[4].value = 'Expiry Date';
//   header.cells[5].value = 'Total Amount';

//   // Add rows for product data.
//   double totalBill = 0;
//   double totalCGST = 0;
//   double totalSGST = 0;

//   for (var item in items) {
//     final PdfGridRow row = table.rows.add();
//     row.cells[0].value = item['name'];
//     row.cells[1].value = '₹${item['pricePerUnit'].toStringAsFixed(2)}';
//     row.cells[2].value = '${item['quantity']}';
//     row.cells[3].value = '${item['gst']}%';
//     row.cells[4].value = item['expiry'];
//     double itemTotal =
//         (item['pricePerUnit'] * item['quantity']) * (1 + item['gst'] / 100);
//     row.cells[5].value = '₹${itemTotal.toStringAsFixed(2)}';

//     totalBill += itemTotal;
//     totalCGST += (item['pricePerUnit'] * item['quantity']) * (item['gst'] / 200);
//     totalSGST += (item['pricePerUnit'] * item['quantity']) * (item['gst'] / 200);
//   }

//   // Set column widths for better alignment.
//   table.columns[0].width = 150;
//   table.columns[1].width = 80;
//   table.columns[2].width = 80;
//   table.columns[3].width = 60;
//   table.columns[4].width = 80;
//   table.columns[5].width = 100;

//   // Draw the table on the PDF.
//   table.draw(page: page, bounds: const Rect.fromLTWH(10, 170, 0, 0));

//   // Add total at the bottom of the table.
//   graphics.drawString(
//     'Total Amount: ₹${totalBill.toStringAsFixed(2)}',
//     PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold),
//     bounds: const Rect.fromLTWH(10, 400, 250, 20),
//   );

//   graphics.drawString(
//     'Total CGST: ₹${totalCGST.toStringAsFixed(2)}\nTotal SGST: ₹${totalSGST.toStringAsFixed(2)}',
//     PdfStandardFont(PdfFontFamily.helvetica, 12),
//     bounds: const Rect.fromLTWH(10, 420, 250, 40),
//   );

//   // Save and handle the PDF based on the platform.
//   List<int> bytes = await document.save();
//   document.dispose();

//   if (kIsWeb) {
//     WebPdfDownloader.webpdfDownload(bytes);
//   } else {
//     MobilePdfDownloader.mobilePdfDownload(bytes);
//   }
// }
