import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:realtime_chat/apps/chat/domain/call_service.dart';

class CallInProgressPage extends StatefulWidget {
  final CallService callService;
  final String callerId;

  const CallInProgressPage({
    super.key,
    required this.callService,
    required this.callerId,
  });

  @override
  _CallInProgressPageState createState() => _CallInProgressPageState();
}

class _CallInProgressPageState extends State<CallInProgressPage> {
  bool isMicOn = true;
  bool isSpeakerOn = false;

  @override
  void initState() {
    super.initState();
  }

  void _toggleMic() async {
    final localStream = widget.callService.getLocalStream();
    if (localStream != null) {
      for (var track in localStream.getAudioTracks()) {
        track.enabled = !isMicOn;
      }
    }
    setState(() {
      isMicOn = !isMicOn;
    });
  }

  void _toggleSpeaker() async {
    await widget.callService.setSpeakerMode(!isSpeakerOn);
    setState(() {
      isSpeakerOn = !isSpeakerOn;
    });
  }

  void _endCall() {
    widget.callService.endCall();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Llamada en curso...",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: 'mic',
                  onPressed: _toggleMic,
                  backgroundColor: isMicOn ? Colors.green : Colors.grey,
                  child: Icon(isMicOn ? Icons.mic : Icons.mic_off),
                ),
                const SizedBox(width: 20),
                FloatingActionButton(
                  heroTag: 'speaker',
                  onPressed: _toggleSpeaker,
                  backgroundColor: isSpeakerOn ? Colors.green : Colors.grey,
                  child: Icon(isSpeakerOn ? Icons.volume_up : Icons.volume_off),
                ),
                const SizedBox(width: 20),
                FloatingActionButton(
                  heroTag: 'endCall',
                  onPressed: _endCall,
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.call_end),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
