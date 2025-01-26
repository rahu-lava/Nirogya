import 'package:universal_html/html.dart' as html;
import 'dart:typed_data';

class WebPdfDownloader {
  static webpdfDownload(bytes) {
    final blob = html.Blob([Uint8List.fromList(bytes)], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);

    // Create an anchor element and trigger the download.
    final anchor = html.AnchorElement(href: url)
      ..target = 'blank'
      ..download = 'bill.pdf';
    anchor.click();

    // Clean up the URL.
    html.Url.revokeObjectUrl(url);
  }
}
