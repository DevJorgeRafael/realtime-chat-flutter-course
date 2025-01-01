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

Future<void> handleGalleryAction(Function(String) onMediaSelected) async {
  // final hasPermission = await PermissionsUtil.requestStoragePermission();
  // if (!hasPermission) {
  //   print('Permiso de almacenamiento denegado');
  //   return;
  // }

  final picker = ImagePicker();

  // Seleccionar imagen o video
  final XFile? pickedFile = await picker.pickMedia(
    imageQuality: 85,
    requestFullMetadata: true, // Obtener detalles adicionales
  );

  if (pickedFile == null) {
    print('No seleccionó ningún archivo');
    return;
  }

  print('Archivo seleccionado: ${pickedFile.path}');
  onMediaSelected(pickedFile.path); // Inserción en los mensajes
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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('File attached: $fileName')),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No file selected')),
    );
  }
}
