import 'dart:io';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';



void printPdf(String filePath) async {
  final file = File(filePath);

  if (await file.exists()) {
    // Read the file as bytes
    final pdfBytes = await file.readAsBytes();

    // Print the PDF
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfBytes,
    );
  } else {
    debugPrint('File not found at $filePath');
  }
}
