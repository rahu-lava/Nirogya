import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:nirogya/Utils/print_pdf.dart'; // Ensure this is your print utility
import 'package:nirogya/Utils/share_file.dart'; // Ensure this is your share utility

class MobilePdfDownloader {
  static Future<void> mobilePdfDownload(List<int> bytes, bool isShare) async {
    try {
      // Get the app's documents directory
      final directory = await getApplicationDocumentsDirectory();
      final String filePath = "${directory.path}/bill.pdf";

      // Save the PDF file
      final File file = File(filePath);
      await file.writeAsBytes(bytes);

      // Ensure the file exists
      if (await file.exists()) {
        print('PDF saved at: $filePath');

        if (isShare) {
          // Share the PDF
          shareFile(filePath);
        } else {
          // Print the PDF
          printPdf(filePath);
        }
      } else {
        print('File not found after saving at: $filePath');
      }
    } catch (e) {
      print('Error while saving, sharing, or printing PDF: $e');
    }
  }
}
