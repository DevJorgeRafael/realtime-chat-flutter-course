import 'dart:io';

import 'package:flutter/material.dart';
import 'package:realtime_chat/apps/auth/domain/auth_service.dart';
import 'package:realtime_chat/apps/home/widgets/video_player_widget.dart';
import 'package:realtime_chat/injection_container.dart';
import 'package:realtime_chat/shared/service/file_manager.dart';
import 'package:realtime_chat/shared/utils/abrir_enlace_util.dart';

class ChatMessage extends StatelessWidget {
  final String? message;
  final String? audioUrl;
  final String? imageUrl;
  final String? videoUrl;
  final String? filePath;
  final String? fileName;

  final String uid;
  final AnimationController animationController;

  const ChatMessage({
    super.key,
    this.message,
    this.audioUrl,
    this.filePath,
    this.fileName,
    this.imageUrl,
    this.videoUrl,
    required this.uid,
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    final authService = sl<AuthService>();
    final isMine = uid == authService.user.id;

    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor:
            CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        child: _buildMessage(context, isMine, fileName, filePath),
      ),
    );
  }

  Widget _buildMessage(BuildContext context, bool isMine, String? fileName, String? filePath) {
    if (imageUrl != null) {
      return _buildImageMessage(context, isMine);
    } else if (videoUrl != null) {
      return _buildVideoMessage(context, isMine);
    } else if(filePath != null && fileName != null) {
      return _buildFileMessage(context, isMine, filePath, fileName);
    }
    else {
      return _buildTextMessage(context, isMine, message ?? "");
    }
  }

  Widget _buildTextMessage(BuildContext context, bool isMine, String message) {
    return Align(
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
        child: GestureDetector(
          onTap: () => _handleTap(context, message),
          child: Text(
            message,
            style: TextStyle(
              color: _isLink(message)
                  ? (isMine ? Colors.blue.shade200 : Colors.blue)
                  : (isMine ? Colors.white : Colors.black87),
              decoration: _isLink(message)
                  ? TextDecoration.underline
                  : TextDecoration.none,
              decorationColor: isMine ? Colors.blue.shade200 : Colors.blue,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageMessage(BuildContext context, bool isMine) {
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 5,
          left: isMine ? 50 : 5,
          right: isMine ? 5 : 50,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: imageUrl != null &&
                  (imageUrl!.startsWith('/') || imageUrl!.startsWith('file://'))
              ? Image.file(
                  File(imageUrl!),
                  fit: BoxFit.cover,
                )
              : Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image, color: Colors.red);
                  },
                ),
        ),
      ),
    );
  }

Widget _buildVideoMessage(BuildContext context, bool isMine) {
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 5,
          left: isMine ? 50 : 5,
          right: isMine ? 5 : 50,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: VideoPlayerWidget(videoUrl: videoUrl!),
        ),
      ),
    );
  }

  Widget _buildFileMessage(BuildContext context, bool isMine, String filePath, String fileName) {
    return Align(
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
        child: GestureDetector(
          onTap: () => FileManager.openFile(filePath),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.insert_drive_file, color: Colors.blue),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  fileName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isMine ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  bool _isLink(String text) {
    final Uri? uri = Uri.tryParse(text);
    return uri != null && (uri.hasScheme || uri.host.isNotEmpty);
  }

  void _handleTap(BuildContext context, String text) async {
    if (_isLink(text)) {
      await abrirEnlaceUtil(context, text);
    }
  }
}
