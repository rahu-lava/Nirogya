import 'package:universal_html/html.dart' as html;
import 'dart:typed_data';

class WebPdfDownloader {
  static webpdfDownload(bytes, bool isShare) {
    final blob = html.Blob([Uint8List.fromList(bytes)], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);

    if (isShare) {
      // Share the PDF
      _sharePdf(url);
    } else {
      // Download the PDF
      _downloadPdf(url);
    }

    // Clean up the URL
    html.Url.revokeObjectUrl(url);
  }

  static void _downloadPdf(String url) {
    // Create a temporary anchor element to open the PDF in a new tab
    final anchor = html.AnchorElement(href: url)..target = 'blank';
    anchor.click();
  }

  static void _sharePdf(String url) {
    // Create an anchor element and trigger the download
    final anchor = html.AnchorElement(href: url)
      ..target = 'blank'
      ..download = 'bill.pdf';
    anchor.click();
  }
}
