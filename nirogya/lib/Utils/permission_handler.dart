import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandlerUtil {
  static Future<void> requestPermissions(BuildContext context) async {
    if (kIsWeb) {
      return; // Skip permission requests on the web
    }

    // Request camera permission
    var cameraStatus = await Permission.camera.request();

    // Check if camera permission is denied
    if (cameraStatus.isDenied || cameraStatus.isPermanentlyDenied) {
      // Show dialog if camera permission is denied
      _showPermissionDialog(context);
    }
  }

  static void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Camera Permission Required"),
        content: const Text(
          "We need camera permission to proceed. Please grant the required permission.",
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Close the dialog
              await _requestCameraPermission(); // Request permission again
            },
            child: const Text("Allow"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              openAppSettings(); // Redirect to app settings
            },
            child: const Text("Settings"),
          ),
        ],
      ),
    );
  }

  static Future<void> _requestCameraPermission() async {
    await Permission.camera.request(); // Request camera permission
  }
}