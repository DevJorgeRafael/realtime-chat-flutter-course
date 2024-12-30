import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:realtime_chat/apps/home/helpers/sound_helpers.dart';
import 'package:realtime_chat/apps/home/presentation/pages/media_picker_page.dart';
import 'package:realtime_chat/shared/service/file_manager.dart';
import 'package:realtime_chat/shared/utils/file_selector.dart';
import 'package:realtime_chat/shared/utils/permissions_util.dart';

Future<void> handleAudioStart(BuildContext context) async {
  final hasPermission = await PermissionsUtil.requestMicrophonePermission();
  if (hasPermission) {
    await startRecording();
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Microphone permission denied')),
    );
  }
}

Future<void> handleAudioStop(BuildContext context) async {
  await stopRecording();
}

Future<void> handleGalleryAction(BuildContext context) async {
  // Lógica para abrir galería
  final hasPermission = await PermissionsUtil.requestStoragePermission();
  if (hasPermission) {
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => const MediaPickerPage())
    );
  } else {
    PermissionsUtil.openAppSettingsIfDenied();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Storage permission denied')),
    );
  }
}

Future<void> handleCameraAction(BuildContext context) async {
  final hasPermission = await PermissionsUtil.requestCameraPermission();
  if (hasPermission) {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      await FileManager.saveFile(photo.path, 'Images');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image captured: ${photo.path}')),
      );
    }
  }
}

Future<void> handleAttachFileAction(BuildContext context) async {
  // Lógica para adjuntar archivos
  final result = await FileSelector.pickFile(allowedExtensions: ['pdf', 'docx', 'txt', 'xslm', 'zip', 'rar', 'html', 'css', 'js', 'ts']);
  if (result != null) {
    await FileManager.saveFile(result.files.single.path!, 'Documents');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('File attached: ${result.files.single.name}')),
    );
  }
}
