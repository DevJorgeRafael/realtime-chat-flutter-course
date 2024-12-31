import 'dart:io';

import 'package:flutter/material.dart';

class PhotoPreviewPage extends StatelessWidget {
  final String photoPath;
  final void Function(String) onSend;
  const PhotoPreviewPage({
    super.key, 
    required this.photoPath,
    required this.onSend,
    });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Preview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.send, color: Colors.red),
            onPressed: () { 
              onSend(photoPath);
              Navigator.pop(context, true);
            } //Eviar la foto
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Image.file(
              File(photoPath),
              fit: BoxFit.contain
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, false), //Descartar la foto
            child: const Text('Descartar', style: TextStyle(color: Colors.red)),
          )

        ],
      )
    );
  }
}