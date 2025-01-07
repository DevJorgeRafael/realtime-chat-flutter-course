import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

enum MediaType { image, video }

class MediaPreviewPage extends StatefulWidget {
  final String filePath;
  final MediaType mediaType;
  final Function(String) onSend;

  const MediaPreviewPage({
    super.key,
    required this.filePath,
    required this.mediaType,
    required this.onSend,
  });

  @override
  State<MediaPreviewPage> createState() => _MediaPreviewPageState();
}

class _MediaPreviewPageState extends State<MediaPreviewPage> {
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    if (widget.mediaType == MediaType.video) {
      _videoController = VideoPlayerController.file(File(widget.filePath))
        ..initialize().then((_) {
          setState(() {}); // Actualizar estado después de inicializar
        });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mediaType == MediaType.image
            ? "Preview Image"
            : "Preview Video"),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              widget.onSend(widget.filePath); // Llamar al callback
              Navigator.pop(context); // Cerrar la vista previa
            },
          ),
        ],
      ),
      body: Center(
        child: widget.mediaType == MediaType.image
            ? Image.file(
                File(widget.filePath),
                fit: BoxFit.contain,
              )
            : _videoController != null && _videoController!.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: VideoPlayer(_videoController!),
                  )
                : const CircularProgressIndicator(),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildFloatingActionButton() {
    if (widget.mediaType == MediaType.video) {
      return FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          if (_videoController != null &&
              _videoController!.value.isInitialized) {
            if (_videoController!.value.isPlaying) {
              _videoController!.pause();
            } else {
              _videoController!.play();
            }
            setState(() {});
          }
        },
        child: Icon(
          _videoController != null && _videoController!.value.isPlaying
              ? Icons.pause
              : Icons.play_arrow,
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
