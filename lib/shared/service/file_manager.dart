import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class FileManager {
  /// Obtiene la ruta base para guardar los archivos.
  static Future<String> getBaseDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final basePath = '${directory.path}/Red Social UTN/media';

    // Crea las carpetas si no existen.
    final folders = ['Images', 'Videos', 'Audio', 'Documents'];
    for (var folder in folders) {
      final path = '$basePath/$folder';
      final dir = Directory(path);
      if (!await dir.exists()) {
        print('Creating directory: $path');
        await dir.create(recursive: true);
      }
    }
    return basePath;
  }

  /// Guarda un archivo en la carpeta correspondiente según el tipo.
  static Future<void> saveFile(String filePath, String fileType) async {
    try {
      final basePath = await getBaseDirectory();
      final destinationPath = '$basePath/$fileType';
      final file = File(filePath);
      final fileName = file.uri.pathSegments.last;

      // Verifica si las carpetas existen antes de copiar
      final dir = Directory(destinationPath);
      if(!await dir.exists()) {
        print('Destination folder dows not exist. Creating: $destinationPath');
        await dir.create(recursive: true);
      }

      await file.copy('$destinationPath/$fileName');
      print('File saved: $filePath -> $destinationPath/$fileName');
    } catch(e) {
      print('Error saving file: $e');
    }
  }

  /// Lista los archivos de una carpeta específica.
  static Future<List<FileSystemEntity>> listFiles(String fileType) async {
    final basePath = await getBaseDirectory();
    final folderPath = '$basePath/$fileType';
    final directory = Directory(folderPath);
    return directory.listSync();
  }

  /// Abre un archivo utilizando la herramienta predeterminada del sistema.
  static Future<void> openFile(String filePath) async {
    try {
      final result = await OpenFile.open(filePath);
      if (result.type != ResultType.done) {
        print('Error opening file: ${result.message}');
      }
    } catch(e) {
      print('Error opening file: $e');
    }
  } 
}
