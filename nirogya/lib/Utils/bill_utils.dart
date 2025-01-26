import 'dart:ffi';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/foundation.dart'; // For kIsWeb.
import 'package:flutter/material.dart';
import 'package:nirogya/Utils/mobilePdfDownloader.dart';
import 'package:nirogya/Utils/share_file.dart';
import 'package:permission_handler/permission_handler.dart'; // For permission handling.
import 'package:share_plus/share_plus.dart'; // For iOS sharing.
import 'package:path_provider/path_provider.dart'; // For saving files locally.
import 'package:syncfusion_flutter_pdf/pdf.dart'; // For generating PDFs.
import 'package:universal_html/html.dart'
    as html; // For web-specific functionality.
import 'package:document_file_save_plus/document_file_save_plus.dart';

Future<void> generateBillPdf(
    BuildContext context, List<Map<String, dynamic>> items , bool isShare) async {
  // Request necessary permissions for platforms (e.g., Android).

  // Create a PDF document.
  final PdfDocument document = PdfDocument();

  // Add a page to the document.
  final PdfPage page = document.pages.add();

  // Draw text on the page.
  page.graphics.drawString(
    'Your Company Name',
    PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold),
    brush: PdfSolidBrush(PdfColor(0, 0, 0)),
    bounds: const Rect.fromLTWH(0, 0, 0, 0),
  );

  // Create a table.
  final PdfGrid table = PdfGrid();
  table.columns.add(count: 3);

  // Add header row.
  final PdfGridRow header = table.headers.add(1)[0];
  header.cells[0].value = 'Item';
  header.cells[1].value = 'Quantity';
  header.cells[2].value = 'Price';

  // Add data rows.
  for (var item in items) {
    final PdfGridRow row = table.rows.add();
    row.cells[0].value = item['name'];
    row.cells[1].value = item['quantity'].toString();
    row.cells[2].value = '\$${item['price'].toStringAsFixed(2)}';
  }

  // Draw the table.
  table.draw(
    page: page,
    bounds: const Rect.fromLTWH(0, 50, 0, 0),
  );

  // Save the document.
  List<int> bytes = await document.save();
  document.dispose();

  // Handle platform-specific saving.
  if (kIsWeb) {
    // Web platform-specific saving using 'universal_html'.
    final blob = html.Blob([Uint8List.fromList(bytes)], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);

    // Create an anchor element and trigger the download.
    final anchor = html.AnchorElement(href: url)
      ..target = 'blank'
      ..download = 'bill.pdf';
    anchor.click();

    // Clean up the URL.
    html.Url.revokeObjectUrl(url);
    
  } else if (Platform.isIOS) {
    // iOS
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/bill.pdf';
    final file = File(filePath);
    await file.writeAsBytes(bytes);

    // Share the file
    // await Share.shareXFiles([XFile(filePath)], text: 'Here is your bill');
  } else if (Platform.isAndroid) {
    final directory = await getApplicationDocumentsDirectory();

    // // final Directory? filePath = '${directory.path}/bill.pdf';
    final String filePath = "${directory.path}/bill.pdf";

    final File file = File(filePath);
    // FileSaveUtil.saveFile(context, bytes, "bill2.pdf");
    print('PDF saved at: $filePath');

    shareFile(filePath);
  } else {
    throw UnsupportedError('Unsupported platform');
  }
}

Future<bool> _requestPermission(BuildContext context) async {
  if (kIsWeb) return true; // No permissions needed for web.

  // Check and request storage permissions (for Android/Linux).
  if (Platform.isAndroid || Platform.isLinux) {
    var status = await Permission.storage.status;

    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      // Guide the user to app settings.
      await _showSettingsDialog(context);
      return false;
    } else if (status.isDenied) {
      // Show a dialog explaining the need for permissions.
      await _showPermissionDialog(context);
      status = await Permission.storage.request();

      if (status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permission granted!')),
        );
        return true;
      } else if (status.isPermanentlyDenied) {
        await _showSettingsDialog(context);
      }
    }
  }

  // For iOS and other platforms, assume permissions are not required.
  return true;
}

Future<void> _showPermissionDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
            'Storage permission is required to save the PDF file. Please allow permissions to continue.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              // Retry permission request.
              await Permission.storage.request().then((status) => {
                    if (status.isGranted)
                      {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Permission granted!')),
                        )
                      }
                    else
                      {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Permission still denied!')),
                        )
                      }
                  });
            },
            child: const Text('Ask Again'),
          ),
        ],
      );
    },
  );
}

Future<void> _showSettingsDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
          'Storage permission is permanently denied. Please open settings and enable the permission manually to save the PDF file.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await openAppSettings(); // Opens the app settings.
            },
            child: const Text('Open Settings'),
          ),
        ],
      );
    },
  );
}
