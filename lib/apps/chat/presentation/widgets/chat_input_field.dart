import 'package:flutter/material.dart';
import 'package:realtime_chat/apps/auth/domain/auth_service.dart';
import 'package:realtime_chat/apps/chat/domain/chat_service.dart';
import 'package:realtime_chat/apps/chat/domain/socket_service.dart';
import 'package:realtime_chat/apps/chat/helpers/file_chat_helpers.dart';
import 'package:realtime_chat/apps/chat/helpers/insert_message_helpers.dart';
import 'package:realtime_chat/apps/chat/presentation/widgets/chat_message_widget.dart';
import 'package:realtime_chat/injection_container.dart';

class ChatInputField extends StatefulWidget {
  final Function(String) onSendMessage;
  final List<ChatMessageWidget> messages; 
  final TickerProvider vsync; 
  final Function(List<ChatMessageWidget>) updateMessages; 

  const ChatInputField({
    super.key,
    required this.onSendMessage,
    required this.messages,
    required this.vsync,
    required this.updateMessages,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isTyping = false;

  late SocketService socketService;
  late ChatService chatService;
  late AuthService authService;

  @override
  void initState() {
    super.initState();
    socketService = sl<SocketService>();
    chatService = sl<ChatService>();
    authService = sl<AuthService>();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      onChanged: (text) {
                        setState(() => _isTyping = text.trim().isNotEmpty);
                      },
                      decoration: const InputDecoration(
                        hintText: "Escribe un mensaje...",
                        border: InputBorder.none,
                      ),
                      focusNode: _focusNode,
                    ),
                  ),
                  if (!_isTyping)
                    _buildActionIcons(), // Ocultar iconos al escribir
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          if (_isTyping)
            _buildSendButton(), // Mostrar botón de enviar solo al escribir
        ],
      ),
    );
  }

  Widget _buildSendButton() {
    return FloatingActionButton(
      onPressed: () =>
          _isTyping ? _sendMessage(_textController.text.trim()) : null,
      mini: true,
      backgroundColor: Colors.red,
      elevation: 2,
      child: const Icon(Icons.send, color: Colors.white),
    );
  }

  Widget _buildActionIcons() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.photo, color: Colors.grey),
          onPressed: () => _handleMediaSelection(context, "image"),
        ),
        IconButton(
          icon: const Icon(Icons.video_camera_back, color: Colors.grey),
          onPressed: () => _handleMediaSelection(context, "video"),
        ),
        IconButton(
          icon: const Icon(Icons.photo_camera, color: Colors.grey),
          onPressed: () => _handleMediaSelection(context, "camera"),
        ),
        IconButton(
          icon: const Icon(Icons.attach_file, color: Colors.grey),
          onPressed: () => _handleMediaSelection(context, "file"),
        ),
      ],
    );
  }



  void _sendMessage(String text) {
    if (text.isEmpty) return;

    _textController.clear();
    _focusNode.requestFocus();

    widget.onSendMessage(text); 

    // Solo enviar los mensajes de texto al backend
    socketService.emit('mensaje-personal', {
      'from': authService.user.id,
      'to': chatService.userReceiver.id,
      'message': text,
      'type': 'text',
      'fileUrl': null,
    });

    setState(() => _isTyping = false);
  }


  Future<void> _handleMediaSelection(BuildContext context, String type) async {
    String? filePath;
    switch (type) {
      case "image":
        filePath = await handlePhotoAction(context);
        break;
      case "video":
        filePath = await handleVideoAction(context);
        break;
      case "camera":
        filePath = await handleCameraAction(context);
        break;
      case "file":
        filePath = await handleAttachFileAction(context);
        break;
    }

    if (filePath != null) {
      final fileName = filePath.split('/').last;

      InsertMessageHelper.insertFileMessage(
        filePath: filePath,
        fileName: fileName,
        fileType: type, 
        userId: authService.user.id,
        receiverId: chatService.userReceiver.id,
        messages: widget.messages,
        vsync: widget.vsync, 
        updateMessages:
            widget.updateMessages,
      );

    }
  }


  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
