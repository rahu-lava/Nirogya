import 'dart:io';
// import 'dart:js';

import 'package:nirogya/Utils/share_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:typed_data';

import 'package:universal_html/js.dart';

class WebPdfDownloader {
  static webpdfDownload(bytes) async {
    if (Platform.isIOS) {
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
    }
  }
}
