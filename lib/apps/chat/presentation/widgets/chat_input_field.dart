import 'package:flutter/material.dart';
import 'package:realtime_chat/apps/auth/domain/auth_service.dart';
import 'package:realtime_chat/apps/chat/domain/chat_service.dart';
import 'package:realtime_chat/apps/chat/domain/socket_service.dart';
import 'package:realtime_chat/apps/chat/helpers/file_chat_helpers.dart';
import 'package:realtime_chat/injection_container.dart';

class ChatInputField extends StatefulWidget {
  final Function(String) onSendMessage;
  final Function(String) onSendFile;

  const ChatInputField({
    super.key,
    required this.onSendMessage,
    required this.onSendFile,
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              onChanged: (text) =>
                  setState(() => _isTyping = text.trim().isNotEmpty),
              decoration: const InputDecoration.collapsed(
                  hintText: 'Escribe un mensaje...'),
              focusNode: _focusNode,
            ),
          ),
          _isTyping ? _buildSendButton() : _buildActionIcons(),
        ],
      ),
    );
  }

  Widget _buildSendButton() {
    return IconButton(
      icon: const Icon(Icons.send, color: Colors.red),
      onPressed: () =>
          _isTyping ? _sendMessage(_textController.text.trim()) : null,
    );
  }

  Widget _buildActionIcons() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.photo, color: Colors.grey),
          onPressed: () => handlePhotoAction(context, _sendFile),
        ),
        IconButton(
          icon: const Icon(Icons.video_chat, color: Colors.grey),
          onPressed: () => handleVideoAction(context, _sendFile),
        ),
        IconButton(
          icon: const Icon(Icons.photo_camera, color: Colors.grey),
          onPressed: () => handleCameraAction(context, _sendFile),
        ),
        IconButton(
          icon: const Icon(Icons.attach_file, color: Colors.grey),
          onPressed: () => handleAttachFileAction(
              context, (filePath, _) => _sendFile(filePath)),
        ),
      ],
    );
  }

  void _sendMessage(String text) {
    if (text.isEmpty) return;

    _textController.clear();
    _focusNode.requestFocus();

    // 🔥 Guarda el mensaje en la UI inmediatamente
    widget.onSendMessage(text);

    setState(() => _isTyping = false);
  }

  void _sendFile(String filePath) {
    widget.onSendFile(filePath);
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
