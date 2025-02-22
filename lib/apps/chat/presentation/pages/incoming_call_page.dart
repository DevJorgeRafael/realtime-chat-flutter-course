import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:realtime_chat/apps/chat/domain/call_service.dart';
import 'package:realtime_chat/apps/chat/presentation/pages/call_in_progress_page.dart';

class IncomingCallPage extends StatelessWidget {
  final String callerId;
  final CallService callService;
  final RTCSessionDescription offer; // ✅ Ahora pasamos la oferta real

  const IncomingCallPage({
    super.key,
    required this.callerId,
    required this.callService,
    required this.offer, // ✅ Se recibe la oferta real desde la UI
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.8),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Llamada entrante...",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: 'reject',
                  onPressed: () {
                    callService.socketService
                        .emit('webrtc-hangup', {'to': callerId});
                    Navigator.pop(context);
                  },
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.call_end),
                ),
                const SizedBox(width: 40),
                FloatingActionButton(
                  heroTag: 'accept',
                  onPressed: () async {
                    await callService.acceptCall(callerId, offer);

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CallInProgressPage(
                          callService: callService,
                          callerId: callerId,
                        ),
                      ),
                    );
                  },

                  backgroundColor: Colors.green,
                  child: const Icon(Icons.call),
                )


              ],
            ),
          ],
        ),
      ),
    );
  }
}
