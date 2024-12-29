import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class PermissionsUtil {
  static Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid && await Permission.storage.isDenied) {
      // Para Android 11+ usa manageExternalStorage.
      if (await Permission.manageExternalStorage.isGranted) {
        return true;
      }
      final status = await Permission.manageExternalStorage.request();
      return status.isGranted;
    } else {
      // Manejo para versiones anteriores.
      final status = await Permission.storage.request();
      return status.isGranted;
    }
  }

  static Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  static Future<bool> requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  static Future<void> openAppSettingsIfDenied() async {
    if (await Permission.storage.isPermanentlyDenied) {
      await openAppSettings();
    }
  }
}