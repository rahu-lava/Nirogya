import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

class SaveImageUtil {
  /// Save the image to the specified directory in the ApplicationDocumentsDirectory.
  Future<String> saveImage(String directory, String userFilePath) async {
    // Get the application documents directory
    final dir = await getApplicationDocumentsDirectory();

    // Ensure the directory exists
    final directoryPath = Directory("${dir.path}/$directory");
    if (!await directoryPath.exists()) {
      await directoryPath.create(recursive: true); // Create directory if it doesn't exist
    }

    // Generate a random filename using UUID
    final filename = Uuid().v4() + extension(userFilePath);

    // Define the new file path
    final String filePath = "${directoryPath.path}/$filename";

    // Copy the file from the user's provided path to the new path
    final userFile = File(userFilePath);
    if (await userFile.exists()) {
      await userFile.copy(filePath); // Copy the file
      return filePath; // Return the new file path
    } else {
      throw Exception("The file does not exist at the provided path.");
    }
  }
}
