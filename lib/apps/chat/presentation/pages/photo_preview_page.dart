import 'dart:io';
import 'package:flutter/material.dart';

class PhotoPreviewPage extends StatefulWidget {
  final String photoPath;

  const PhotoPreviewPage({
    super.key,
    required this.photoPath,
  });

  @override
  State<PhotoPreviewPage> createState() => _PhotoPreviewPageState();
}

class _PhotoPreviewPageState extends State<PhotoPreviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.pop(context, false); // No enviar la imagen
          },
        ),
      ),
      body: Center(
        child: Image.file(
          File(widget.photoPath),
          fit: BoxFit.contain,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          Navigator.pop(context, true); // Confirmar envío
        },
        child: const Icon(Icons.send, color: Colors.white),
      ),
    );
  }
}
