import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:realtime_chat/apps/chat/models/messages_response.dart';
import 'package:realtime_chat/shared/service/file_manager.dart';
import 'package:realtime_chat/apps/chat/presentation/widgets/video_player_widget.dart';
import 'package:realtime_chat/shared/utils/abrir_enlace_util.dart';

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

    final filePath = widget.message.fileUrl;

    if (filePath != null && File(filePath).existsSync()) {
      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMine = widget.message.isMine;
    String time = DateFormat('HH:mm').format(widget.message.createdAt);

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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            margin: EdgeInsets.only(
              bottom: 5,
              left: isMine ? 50 : 5,
              right: isMine ? 5 : 50,
            ),
            decoration: BoxDecoration(
              color: isMine ? Colors.red.shade400 : Colors.grey,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: isMine
                    ? const Radius.circular(20)
                    : const Radius.circular(0),
                bottomRight: isMine
                    ? const Radius.circular(0)
                    : const Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildMessageContent(),
                const SizedBox(height: 3),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 11,
                    color: isMine ? Colors.white70 : const Color.fromARGB(235, 236, 236, 236),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageContent() {
    if (widget.message.type == "text") {
      bool isLink = widget.message.message != null &&
          widget.message.message!.startsWith("http");

      return GestureDetector(
        onTap: isLink
            ? () => abrirEnlaceUtil(context, widget.message.message!)
            : null,
        child: Text(
          widget.message.message ?? "",
          style: TextStyle(
            fontSize: 16,
            color: isLink ? Colors.blue[200] : Colors.white,
            decoration: isLink ? TextDecoration.underline : TextDecoration.none, 
            decorationColor: Colors.blue[200],
            decorationThickness: 1.5
          ),
        ),
      );
    }

    switch (widget.message.type) {
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

    if (widget.message.fileUrl != null &&
        File(widget.message.fileUrl!).existsSync()) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(
          File(widget.message.fileUrl!),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.broken_image, color: Colors.grey);
          },
        ),
      );
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
      onTap: () async {
        final filePath = widget.message.fileUrl;
        if (filePath != null && filePath.isNotEmpty) {
          if (await File(filePath).exists()) {
            await FileManager.openFile(filePath);
          } else {
            print('El archivo no existe en la ruta: $filePath');
          }
        } else {
          print('No se puede abrir el archivo: Ruta vacía o nula.');
        }
      },
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
