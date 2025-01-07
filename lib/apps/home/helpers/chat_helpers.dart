import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:realtime_chat/apps/home/presentation/pages/media_preview_page.dart';
import 'package:realtime_chat/apps/home/presentation/pages/camera_view_page.dart';
import 'package:realtime_chat/apps/home/presentation/pages/video_view_page.dart';
import 'package:realtime_chat/shared/service/file_manager.dart';
import 'package:realtime_chat/shared/utils/file_selector.dart';
// import 'package:realtime_chat/shared/utils/permissions_util.dart';

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
    BuildContext context, void Function(String) insertMediaCallback) async {
  final ImagePicker picker = ImagePicker();

  // Mostrar opciones para capturar una foto o grabar un video.
  final action = await showModalBottomSheet<String>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        color: Colors.black,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera, color: Colors.white),
              title: const Text('Take Photo',
                  style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context, 'photo'),
            ),
            ListTile(
              leading: const Icon(Icons.videocam, color: Colors.white),
              title: const Text('Record Video',
                  style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context, 'video'),
            ),
          ],
        ),
      );
    },
  );

  if (action == 'photo') {
    // Capturar una foto
    final XFile? photo = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );

    if (photo != null) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CameraViewPage(path: photo.path),
        ),
      );

      if (result == true) {
        insertMediaCallback(photo.path); // Enviar foto seleccionada
      }
    }
  } else if (action == 'video') {
    // Grabar un video
    final XFile? video = await picker.pickVideo(
      source: ImageSource.camera,
      maxDuration: const Duration(minutes: 2),
    );

    if (video != null) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoViewPage(path: video.path),
        ),
      );

      if (result == true) {
        insertMediaCallback(video.path); // Enviar video seleccionado
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
