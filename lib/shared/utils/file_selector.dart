import 'package:file_picker/file_picker.dart';

class FileSelector {
  /// Selecciona un archivo del dispositivo.
  static Future<FilePickerResult?> pickFile({required List<String> allowedExtensions}) async {
    return await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions
    );
  }
}