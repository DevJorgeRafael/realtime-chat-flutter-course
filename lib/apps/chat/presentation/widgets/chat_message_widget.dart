import 'dart:io';
import 'package:flutter/material.dart';
import 'package:realtime_chat/apps/chat/models/messages_response.dart';
import 'package:realtime_chat/shared/service/file_manager.dart';
import 'package:realtime_chat/apps/chat/presentation/widgets/video_player_widget.dart';

class ChatMessageWidget extends StatefulWidget {
  final Message message;
  final AnimationController animationController;

  const ChatMessageWidget({
    super.key,
    required this.message,
    required this.animationController,
  });

  @override
  State<ChatMessageWidget> createState() => _ChatMessageWidgetState();
}

class _ChatMessageWidgetState extends State<ChatMessageWidget> {
  String? _localFilePath;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    if (widget.message.fileUrl == null || widget.message.fileUrl!.isEmpty) {
      setState(() => _isLoading = false);
      return;
    }

    final filePath = widget
        .message.fileUrl; // Ya debería estar descargada en `_cargarHistorial()`

    if (filePath != null && File(filePath).existsSync()) {
      setState(() {
        _localFilePath = filePath;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    bool isMine = widget.message.isMine;

    return FadeTransition(
      opacity: widget.animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: widget.animationController,
          curve: Curves.easeOut,
        ),
        child: Align(
          alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.all(8),
            margin: EdgeInsets.only(
              bottom: 5,
              left: isMine ? 50 : 5,
              right: isMine ? 5 : 50,
            ),
            decoration: BoxDecoration(
              color: isMine ? Colors.red.shade400 : const Color(0xffE4E5E8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: _buildMessageContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageContent() {
    switch (widget.message.type) {
      case "text":
        return Text(
          widget.message.message ?? "",
          style: const TextStyle(fontSize: 16, color: Colors.white),
        );
      case "image":
        return _buildImageMessage();
      case "video":
        return _buildVideoMessage();
      case "file":
        return _buildFileMessage();
      default:
        return const Text("Tipo de mensaje no soportado",
            style: TextStyle(color: Colors.white));
    }
  }

  Widget _buildImageMessage() {
    if (_isLoading) {
      return const Center(
        child: SizedBox(
          width: 25,
          height: 25,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (_localFilePath != null && File(_localFilePath!).existsSync()) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(File(_localFilePath!), fit: BoxFit.cover),
      );
    }

    // Si aún no se ha descargado la imagen, intenta de nuevo
    if (!_isLoading && widget.message.fileUrl == null) {
      _loadImage();
    }

    return const Icon(Icons.broken_image, color: Colors.grey);
  }


  Widget _buildVideoMessage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: VideoPlayerWidget(videoUrl: widget.message.fileUrl ?? ""),
    );
  }

  Widget _buildFileMessage() {
    return GestureDetector(
      onTap: () => FileManager.openFile(_localFilePath ?? ""),
      child: Row(
        children: [
          const Icon(Icons.insert_drive_file, color: Colors.blue),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              widget.message.fileName ?? "Archivo",
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
