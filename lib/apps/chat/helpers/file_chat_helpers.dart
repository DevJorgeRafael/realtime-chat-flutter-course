import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:realtime_chat/apps/chat/presentation/pages/camera_view_page.dart';
import 'package:realtime_chat/apps/chat/presentation/pages/photo_preview_page.dart';
import 'package:realtime_chat/apps/chat/presentation/pages/video_view_page.dart';
import 'package:realtime_chat/shared/service/file_manager.dart';
import 'package:realtime_chat/shared/utils/file_selector.dart';
// import 'package:realtime_chat/shared/utils/permissions_util.dart';

Future<String?> handlePhotoAction(BuildContext context) async {
  final ImagePicker picker = ImagePicker();
  final XFile? photo = await picker.pickImage(source: ImageSource.gallery);

  if (photo != null) {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoPreviewPage(photoPath: photo.path),
      ),
    );

    if (result == true) {
      await FileManager.saveFile(photo.path, 'Images');
      return photo.path;
    }
  }
  return null;
}

Future<String?> handleVideoAction(BuildContext context) async {
  final ImagePicker picker = ImagePicker();
  final XFile? video = await picker.pickVideo(
    source: ImageSource.gallery,
    maxDuration: const Duration(minutes: 5),
  );

  if (video != null) {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => VideoViewPage(videoPath: video.path),
      ),
    );

    if (result == true) {
      await FileManager.saveFile(video.path, 'Videos');
      return video.path;
    }
  }
  return null;
}



Future<String?> handleCameraAction(BuildContext context) async {
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
              title: const Text('Tomar Foto',
                  style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context, 'photo'),
            ),
            ListTile(
              leading: const Icon(Icons.videocam, color: Colors.white),
              title: const Text('Grabar Video',
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
      final result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (context) => CameraViewPage(path: photo.path),
        ),
      );

      if (result == true) {
        await FileManager.saveFile(photo.path, 'Images');
        return photo.path; // ✅ Devuelve la ruta de la imagen
      }
    }
  } else if (action == 'video') {
    // Grabar un video
    final XFile? video = await picker.pickVideo(
      source: ImageSource.camera,
      maxDuration: const Duration(minutes: 2),
    );

    if (video != null) {
      final result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (context) => VideoViewPage(videoPath: video.path),
        ),
      );

      if (result == true) {
        await FileManager.saveFile(video.path, 'Videos');
        return video.path; // ✅ Devuelve la ruta del video
      }
    }
  }
  return null; // ❌ No se seleccionó nada
}


Future<String?> handleAttachFileAction(BuildContext context) async {
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
    return filePath;
  } 
  
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('No se seleccionón ningún archivo')),
  );
  
  return null;
}
