import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:realtime_chat/apps/home/helpers/sound_helpers.dart';
import 'package:realtime_chat/apps/home/presentation/pages/media_picker_page.dart';
import 'package:realtime_chat/apps/home/presentation/pages/photo_preview_page.dart';
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

Future<String?> handleAudioStop(BuildContext context) async {
  return await stopRecording();
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

Future<void> handleCameraAction(BuildContext context, void Function(String) insertImageCallBack) async {
  final hasPermission = await PermissionsUtil.requestCameraPermission();
  if (hasPermission) {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PhotoPreviewPage(
          photoPath: photo.path,
          onSend: insertImageCallBack
        )),
      );

      if(result == true) {
        await FileManager.saveFile(photo.path, 'Images');
      }
    }
  }
}

Future<void> handleAttachFileAction(BuildContext context, Function onFileSelected) async {
  // Lógica para adjuntar archivos
  final result = await FileSelector.pickFile(allowedExtensions: [
    'pdf', 'docx', 'txt', 'xslm', 'zip', 'rar', 'html', 'css', 'js', 'ts'
  ]);

  if (result != null) {
    final filePath = result.files.single.path!;
    final fileName = result.files.single.name;

    await FileManager.saveFile(filePath, 'Documents');

    onFileSelected(filePath, fileName);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('File attached: $fileName')),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No file selected')),
    );
  }
}
