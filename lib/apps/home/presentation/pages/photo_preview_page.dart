import 'dart:io';
import 'package:flutter/material.dart';

class PhotoPreviewPage extends StatefulWidget {
  final String photoPath;
  final void Function(String) onSend;

  const PhotoPreviewPage({
    super.key,
    required this.photoPath,
    required this.onSend,
  });

  @override
  State<PhotoPreviewPage> createState() => _PhotoPreviewPageState();
}

class _PhotoPreviewPageState extends State<PhotoPreviewPage>
    with SingleTickerProviderStateMixin {
  final TransformationController _transformationController =
      TransformationController();
  late AnimationController _animationController;
  Animation<Matrix4>? _animation;
  TapDownDetails? _doubleTapDetails;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300), // Duración de la animación
    )..addListener(() {
        _transformationController.value = _animation!.value;
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  void _resetAnimation() {
    _animation = Matrix4Tween(
      begin: _transformationController.value,
      end: Matrix4.identity(),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _animationController.forward(from: 0);
  }

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
            Navigator.pop(context, false); // Descarta la foto
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Función de editar no implementada')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.crop, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Función de recortar no implementada')),
              );
            },
          ),
        ],
      ),
      body: GestureDetector(
        onDoubleTapDown: (details) {
          _doubleTapDetails = details;
        },
        onDoubleTap: () {
          if (_transformationController.value != Matrix4.identity()) {
            _resetAnimation(); // Restablecer con animación
          } else if (_doubleTapDetails != null) {
            final position = _doubleTapDetails!.localPosition;
            _transformationController.value = Matrix4.identity()
              ..translate(-position.dx * 2, -position.dy * 2)
              ..scale(2.0);
          }
        },
        child: Center(
          child: InteractiveViewer(
            transformationController: _transformationController,
            maxScale: 20.0, // Nivel máximo de zoom
            minScale: 1.0, // Nivel mínimo de zoom
            clipBehavior: Clip.none,
            onInteractionEnd: (details) {
              _resetAnimation(); // Restablecer con animación al soltar el pellizco
            },
            child: Image.file(
              File(widget.photoPath),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          widget.onSend(widget.photoPath); // Envía la foto
          Navigator.pop(context, true);
        },
        child: const Icon(Icons.send, color: Colors.white),
      ),
    );
  }
}
