import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:realtime_chat/apps/home/presentation/pages/camera_view_page.dart';
import 'package:realtime_chat/apps/home/presentation/pages/media_gallery_page.dart';
import 'package:realtime_chat/apps/home/presentation/pages/photo_preview_page.dart';
import 'package:realtime_chat/apps/home/presentation/pages/video_view_page.dart';
import 'package:realtime_chat/shared/service/file_manager.dart';
import 'package:realtime_chat/shared/utils/file_selector.dart';
import 'package:realtime_chat/shared/utils/permissions_util.dart';

import 'package:photo_manager/photo_manager.dart';

Future<void> handleGalleryAction(
    BuildContext context, Function(String) onMediaSelected) async {
  final permission = await PermissionsUtil.requestStoragePermission(context);

  if (!permission) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Storage permission denied')),
    );
    return;
  }

  // Mostrar opciones para seleccionar imágenes o videos
  final picker = ImagePicker();

  // Seleccionar imagen o video
  final XFile? pickedFile = await showModalBottomSheet<XFile?>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 160,
        color: Colors.white,
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Select Photo'),
              onTap: () async {
                final image =
                    await picker.pickImage(source: ImageSource.gallery);
                Navigator.pop(context, image);
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: const Text('Select Video'),
              onTap: () async {
                final video =
                    await picker.pickVideo(source: ImageSource.gallery);
                Navigator.pop(context, video);
              },
            ),
          ],
        ),
      );
    },
  );

  // Procesar archivo seleccionado
  if (pickedFile != null) {
    final isImage = pickedFile.path.endsWith('.jpg') ||
        pickedFile.path.endsWith('.jpeg') ||
        pickedFile.path.endsWith('.png');
    final isVideo =
        pickedFile.path.endsWith('.mp4') || pickedFile.path.endsWith('.mov');

    if (isImage || isVideo) {
      // Insertar como mensaje y permitir previsualización
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => isImage
              ? CameraViewPage(
                  path: pickedFile.path) // Previsualización de imagen
              : VideoViewPage(
                  path: pickedFile.path), // Previsualización de video
        ),
      ).then((result) {
        if (result == true) {
          onMediaSelected(pickedFile.path);
        }
      });
    }
  }
}


Future<void> handleCameraAction(
    BuildContext context, void Function(String) insertImageCallBack) async {
  final hasPermission = await PermissionsUtil.requestCameraPermission();
  if (hasPermission) {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);

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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('File attached: $fileName')),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No file selected')),
    );
  }
}
