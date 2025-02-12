import 'package:flutter/material.dart';
import 'package:realtime_chat/apps/chat/models/messages_response.dart';
import 'package:realtime_chat/apps/chat/presentation/widgets/chat_message_widget.dart';
import 'package:realtime_chat/shared/service/file_manager.dart';

class InsertMessageHelper {
  static void insertMessage({
    required Message message,
    required List<ChatMessageWidget> messages,
    required TickerProvider vsync,
    required Function(List<ChatMessageWidget>) updateMessages,
  }) {
    final animationController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 300),
    )..forward();

    final newMessage = ChatMessageWidget(
      message: message,
      animationController: animationController,
    );

    messages.insert(0, newMessage);
    updateMessages([...messages]);
  }

  static void insertTextMessage({
    required String text,
    required String userId,
    required String receiverId,
    required List<ChatMessageWidget> messages,
    required TickerProvider vsync,
    required Function(List<ChatMessageWidget>) updateMessages,
  }) {
    final message = Message(
      from: userId,
      to: receiverId,
      type: "text",
      message: text,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    insertMessage(
      message: message,
      messages: messages,
      vsync: vsync,
      updateMessages: updateMessages,
    );
  }

  static void insertVideoMessage({
    required String videoPath,
    required String userId,
    required String receiverId,
    required List<ChatMessageWidget> messages,
    required TickerProvider vsync,
    required Function(List<ChatMessageWidget>) updateMessages,
  }) {
    final message = Message(
      from: userId,
      to: receiverId,
      type: "video",
      fileUrl: videoPath,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    insertMessage(
      message: message,
      messages: messages,
      vsync: vsync,
      updateMessages: updateMessages,
    );
  }

  static void insertImageMessage({
    required String imagePath,
    required String userId,
    required String receiverId,
    required List<ChatMessageWidget> messages,
    required TickerProvider vsync,
    required Function(List<ChatMessageWidget>) updateMessages,
  }) async {
    // Guarda la imagen en almacenamiento local
    final savedPath =
        await FileManager.downloadAndSaveImage(imagePath) ?? imagePath;

    final message = Message(
      from: userId,
      to: receiverId,
      type: "image",
      fileUrl: savedPath,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    insertMessage(
      message: message,
      messages: messages,
      vsync: vsync,
      updateMessages: updateMessages,
    );
  }

  static void insertFileMessage({
    required String filePath,
    required String fileName,
    required String userId,
    required String receiverId,
    required List<ChatMessageWidget> messages,
    required TickerProvider vsync,
    required Function(List<ChatMessageWidget>) updateMessages,
  }) {
    final message = Message(
      from: userId,
      to: receiverId,
      type: "file",
      fileUrl: filePath,
      fileName: fileName,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    insertMessage(
      message: message,
      messages: messages,
      vsync: vsync,
      updateMessages: updateMessages,
    );
  }
}
