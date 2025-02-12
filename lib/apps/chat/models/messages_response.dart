import 'dart:convert';
import 'package:realtime_chat/apps/auth/domain/auth_service.dart';
import 'package:realtime_chat/injection_container.dart';
import 'package:realtime_chat/shared/service/file_manager.dart';

MessagesResponse mensajesResponseFromJson(String str) =>
    MessagesResponse.fromJson(json.decode(str));

String messagesResponseToJson(MessagesResponse data) =>
    json.encode(data.toJson());

class MessagesResponse {
  final bool ok;
  final List<Message> messages;

  MessagesResponse({
    required this.ok,
    required this.messages,
  });

  factory MessagesResponse.fromJson(Map<String, dynamic> json) =>
      MessagesResponse(
        ok: json["ok"],
        messages: List<Message>.from(
            json["messages"].map((x) => Message.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "messages": List<dynamic>.from(messages.map((x) => x.toJson())),
      };
}

class Message {
  final String from;
  final String to;
  final String type;
  String? fileId; // ID del archivo en el backend
  String? fileUrl; // Ruta local del archivo después de descargarlo
  final String? fileName;
  final String? message;
  final String? room;
  final DateTime createdAt;
  final DateTime updatedAt;

  Message({
    required this.from,
    required this.to,
    required this.type,
    this.fileId,
    this.fileUrl,
    this.fileName,
    this.message,
    this.room,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isMine {
    final authService = sl<AuthService>();
    return from == authService.user.id;
  }

  bool get isFileDownloaded {
    return fileUrl != null && fileUrl!.isNotEmpty;
  }

  Future<void> downloadFileIfNeeded() async {
    if (!isFileDownloaded && fileId != null) {
      final localPath = await FileManager.downloadAndSaveImage(fileId!);
      if (localPath != null) {
        fileUrl = localPath;
      }
    }
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      from: json["from"],
      to: json["to"],
      type: json["type"],
      fileId: json["fileId"],
      fileUrl: json["fileUrl"], // Solo si ya viene del backend
      fileName: json["fileName"],
      message: json["message"],
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
    );
  }

  Future<String?> fetchFileIfNeeded() async {
    if (isFileDownloaded || fileId == null)
      return fileUrl; // Si ya está descargado, usa la ruta local

    String? localPath = await FileManager.downloadAndSaveImage(fileId!);

    if (localPath != null) {
      fileUrl = localPath; // ✅ Guarda la ruta local correctamente
      return localPath;
    }

    return null;
  }

  Map<String, dynamic> toJson() => {
        "from": from,
        "to": to,
        "type": type,
        "fileId": fileId,
        "fileUrl": fileUrl,
        "fileName": fileName,
        "message": message,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
