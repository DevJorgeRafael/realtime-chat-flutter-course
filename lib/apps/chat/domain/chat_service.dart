import 'package:dio/dio.dart';
import 'package:realtime_chat/apps/auth/domain/auth_service.dart';
import 'package:realtime_chat/apps/chat/domain/socket_service.dart';
import 'package:realtime_chat/apps/chat/models/messages_response.dart';
import 'package:realtime_chat/injection_container.dart';

import 'package:realtime_chat/shared/models/user.dart';
import 'package:realtime_chat/shared/service/dio_client.dart';
import 'package:realtime_chat/shared/service/file_manager.dart';
import 'package:realtime_chat/shared/utils/safe_change_notifier.dart';

class ChatService extends SafeChangeNotifier {
  List<Message> messages = [];
  late User userReceiver;
  final SocketService socketService = sl<SocketService>();
  final AuthService authService = sl<AuthService>();

  void clearMessages() {
    messages.clear();
    notifyListeners();
  }

  Future<void> loadChatHistory(String userId) async {
    try {
      final response = await DioClient.instance.get('/messages/$userId');
      final messagesResponse = mensajesResponseFromJson(response.toString());

      messages = messagesResponse.messages;

      for (var message in messages) {
        if( message.type == 'image' && message.fileUrl != null ) {
          final localPath = await FileManager.downloadAndSaveImage(message.fileUrl!);
          if (localPath != null) {
            message.fileUrl = localPath;
          }
        }
      }

      notifyListeners();
    } catch (e) {
      print('Error cargando historial: $e');
    }
  }

  void addReceivedMessage(dynamic payload) {
    final newMessage = Message.fromJson(payload);

    messages.insert(0, newMessage);
    notifyListeners();
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userId = authService.user.id;

    final newMessage = Message(
      from: userId,
      to: userReceiver.id,
      type: "text",
      message: text,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // 🔥 Solo emitir el mensaje, NO insertarlo en la UI
    socketService.emit('mensaje-personal', {
      'from': userId,
      'to': userReceiver.id,
      'message': text,
      'type': newMessage.type,
      'fileUrl': null
    });
  }

  Future<void> sendFile(String fileUrl) async {
    // TODO: Implementar envío de archivos
  }


  Future<String?> uploadFile(String filePath) async {
    try{
      final file = await MultipartFile.fromFile(filePath);
      final formData = FormData.fromMap({
        'file': file,
        'from': authService.user.id,
        'to': userReceiver.id,
        'type': 'image'
      });

      final response = await DioClient.instance.post(
        '/messages/upload', 
        data: formData
      );

      if (response.statusCode == 201) {
        return response.data['fileId'];
      } else {
        print('Error uploading file: ${response.data}');
        return null;
      }

    } catch(e) {
      print('Error uploading file: $e');
      return null;
    }
  }

  Future<void> sendMessageWithFile(String text, String filePath) async {
    // 1️⃣ Enviar el mensaje sin archivo primero
    final message = {
      'from': authService.user.id,
      'to': userReceiver.id,
      'message': text,
      'type': 'text',
      'createdAt': DateTime.now().toIso8601String(),
    };

    socketService.emit('mensaje-personal', message);

    // 2️⃣ Subir el archivo al servidor
    final fileId = await uploadFile(filePath);

    if (fileId != null) {
      // 3️⃣ Enviar un nuevo mensaje con el fileId
      final fileMessage = {
        'from': authService.user.id,
        'to': userReceiver.id,
        'message': '',
        'type': 'image',
        'fileId': fileId,
        'createdAt': DateTime.now().toIso8601String(),
      };

      socketService.emit('mensaje-personal', fileMessage);
    }
  }

}
