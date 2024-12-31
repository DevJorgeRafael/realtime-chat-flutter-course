import 'dart:async';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

FlutterSoundRecorder? _recorder;
Duration _recordingDuration = Duration.zero;
late Timer _recordingTimer;

Future<void> initRecorder() async {
  if (_recorder == null) {
    _recorder = FlutterSoundRecorder();
    await _recorder!.openRecorder();
  }
}

Future<void> startRecording() async {
  if (_recorder == null || _recorder!.isRecording) return;

  final directory = await getApplicationDocumentsDirectory();
  final path = '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.acc';

  try {
    await _recorder!.startRecorder(
      toFile: path,
      codec: Codec.aacMP4,
    );
    print('Recording to: $path');
    _recordingDuration = Duration.zero;

    // Inicia un temporizador para rastrear la duración de la grabación
    _recordingTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      _recordingDuration += Duration(seconds: 1);
    });
  } catch (e) {
    print('Error starting recorder: $e');
  }
}

Future<String?> stopRecording() async {
  if (_recorder == null || !_recorder!.isRecording) {
    print('Recorder is not initialized');
    return null;
  }

  try {
    final path = await _recorder!.stopRecorder();
    print('Recording stopped. File saved at: $path');
    return path;
  } catch (e) {
    print('Error stopping recorder: $e');
    return null;
  }
}

Future<void> disposeRecorder() async {
  if (_recorder != null) {
    await _recorder!.closeRecorder();
    _recorder = null;
  }
}
