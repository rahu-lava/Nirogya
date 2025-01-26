import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandlerUtil {
  static Future<void> requestPermissions(BuildContext context) async {
    // Request permissions directly
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.storage,
    ].request();

    // Check if any permission is denied
    if (statuses.values
        .any((status) => status.isDenied || status.isPermanentlyDenied)) {
      // Show dialog if any permission is denied
      _showPermissionDialog(context);
    }
  }

  static void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Permissions Required"),
        content: const Text(
          "We need camera and storage permissions to proceed. Please grant the required permissions.",
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Close the dialog
              await _requestAllPermissions(); // Request permissions again
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

  static Future<void> _requestAllPermissions() async {
    await [
      Permission.camera,
      Permission.storage,
    ].request(); // Request all ungranted permissions in one step
  }
}
