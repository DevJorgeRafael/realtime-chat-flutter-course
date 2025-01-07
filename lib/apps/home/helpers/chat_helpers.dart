import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:realtime_chat/apps/home/presentation/pages/media_preview_page.dart';
import 'package:realtime_chat/apps/home/presentation/pages/photo_preview_page.dart';
import 'package:realtime_chat/shared/service/file_manager.dart';
import 'package:realtime_chat/shared/utils/file_selector.dart';
import 'package:realtime_chat/shared/utils/permissions_util.dart';
// import 'package:gallery_picker/gallery_picker.dart';

Future<void> handlePhotoAction(BuildContext context, Function(String) insertPhotoCallback) async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.gallery);

    if (photo != null) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MediaPreviewPage(
            filePath: photo.path,
            mediaType: MediaType.image,
            onSend: insertPhotoCallback,
          ),
        ),
      );

      if (result == true) {
        await FileManager.saveFile(photo.path, 'Images');
      }
    }
}

Future<void> handleVideoAction(BuildContext context, Function(String) insertVideoCallback) async {
    final ImagePicker picker = ImagePicker();
    final XFile? video = await picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(minutes: 5),
    );

    if (video != null) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MediaPreviewPage(
            filePath: video.path,
            mediaType: MediaType.video,
            onSend: insertVideoCallback,
          ),
        ),
      );

      if (result == true) {
        await FileManager.saveFile(video.path, 'Videos');
      }
    }
}

Future<void> handleCameraAction(
    BuildContext context, void Function(String) insertImageCallBack) async {
  final hasPermission = await PermissionsUtil.requestCameraPermission();
  if (hasPermission) {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickMedia(imageQuality: 85);

    if (photo != null) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PhotoPreviewPage(
                photoPath: photo.path, onSend: insertImageCallBack)),
      );

      if (result == true) {
        await FileManager.saveFile(photo.path, 'Images');
      }
    }
  }
}

Future<void> handleAttachFileAction(
    BuildContext context, Function onFileSelected) async {
  // Lógica para adjuntar archivos
  final result = await FileSelector.pickFile(allowedExtensions: [
    'pdf',
    'docx',
    'txt',
    'xslm',
    'zip',
    'rar',
    'html',
    'css',
    'js',
    'ts'
  ]);

  if (result != null) {
    final filePath = result.files.single.path!;
    final fileName = result.files.single.name;

    await FileManager.saveFile(filePath, 'Documents');

    onFileSelected(filePath, fileName);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No file selected')),
    );
  }
}
