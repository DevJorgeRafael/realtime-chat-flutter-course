import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MediaPickerPage extends StatefulWidget {
  const MediaPickerPage({super.key});

  @override
  State<MediaPickerPage> createState() => _MediaPickerPageState();
}

class _MediaPickerPageState extends State<MediaPickerPage> {
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _mediaFiles;

  Future<void> _pickMedia(ImageSource source) async {
    final pickedFiles = await _picker.pickMultiImage();
    setState(() {
      _mediaFiles = pickedFiles;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: const Text('Galería')),
      body: Column(
        children: [
          Expanded(
            child: _mediaFiles != null && _mediaFiles!.isNotEmpty
              ? GridView.builder(
                itemCount: _mediaFiles!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0
                ),
                itemBuilder: (context, index) {
                  return Image.file(File(_mediaFiles![index].path));
                }
              ) : const Center(child: Text('No media selected')),
          ),
          ElevatedButton(
            onPressed: () => _pickMedia(ImageSource.gallery),
            child: const Text('Elegir desde la galería'),
          ),
        ],
      ),
    );
  }
}