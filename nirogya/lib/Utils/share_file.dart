import 'dart:io';
import 'package:share_plus/share_plus.dart';

Future<void> shareFile(String filePath) async {
  try {
    final file = File(filePath);

    // Check if the file exists
    if (!await file.exists()) {
      print("File not found at $filePath");
      return;
    }

    // Share the file
    await Share.shareXFiles([XFile(filePath)], text: 'Check out this PDF!');
    print("File shared successfully.");
  } catch (e) {
    print("Error sharing file: $e");
  }
}
