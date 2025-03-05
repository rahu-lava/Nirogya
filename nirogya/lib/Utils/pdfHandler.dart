import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:toasty_box/toast_service.dart';
import 'package:url_launcher/url_launcher.dart'; // For opening WhatsApp
import 'package:share_plus/share_plus.dart'; // For general sharing
import 'package:nirogya/Utils/print_pdf.dart'; // Ensure this is your print utility

class PdfHandler {
  static Future<void> handlePdf(List<int> bytes, bool isShare,
      {String? whatsappNumber}) async {
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
          if (whatsappNumber != null && whatsappNumber.isNotEmpty) {
            // Share the PDF to WhatsApp with the specified number
            await _sendToWhatsApp(filePath, whatsappNumber);
          } else {
            // Open WhatsApp for general sharing
            await _openWhatsAppForSharing(filePath);
          }
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

  // Share the PDF to WhatsApp with a specific number
  static Future<void> _sendToWhatsApp(
      String filePath, String whatsappNumber) async {
    try {
      // Format the WhatsApp number (remove any non-numeric characters)
      final formattedNumber = whatsappNumber.replaceAll(RegExp(r'[^0-9]'), '');

      // Create the WhatsApp URL
      final whatsappUrl = Uri.parse("https://wa.me/+$formattedNumber");
      // print("my number url" + whatsappUrl);

      // Check if WhatsApp can be launched
      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl);
        // Share the file using the share_plus package
        // await Share.shareXFiles([XFile(filePath)],
        //     text: 'Here is the bill PDF.');
      } else {
        await Share.shareXFiles([XFile(filePath)],
            text: 'Here is the bill PDF.');
      }
    } catch (e) {
      print('Error sharing to WhatsApp: $e');
      //   ToastService.showErrorToast(context,
      // length: ToastLength.short,
      // message: "Failed to fetch final Medicine");
    }
  }

  // Open WhatsApp for general sharing
  static Future<void> _openWhatsAppForSharing(String filePath) async {
    try {
      // Share the file using the share_plus package
      await Share.shareXFiles([XFile(filePath)], text: 'Here is the bill PDF.');
    } catch (e) {
      print('Error opening WhatsApp for sharing: $e');
    }
  }
}
