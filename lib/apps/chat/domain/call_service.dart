import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:realtime_chat/apps/chat/domain/socket_service.dart';
import 'package:realtime_chat/injection_container.dart';
import 'package:audioplayers/audioplayers.dart';

class CallService {
  final SocketService socketService = sl<SocketService>();

  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  Function(MediaStream)? onRemoteStream;
  final AudioPlayer _audioPlayer = AudioPlayer();
  Function(String callerId, RTCSessionDescription offer)? onIncomingCall; 

  Future<void> startCall(String userId) async {
    await _setupPeerConnection();

    if (_peerConnection == null) {
      print("❌ Error: _peerConnection es NULL, no se puede iniciar la llamada.");
      return;
    }

    RTCSessionDescription offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);

    // ✅ Agrega logs para ver si la oferta se genera correctamente
    print('📞 Enviado SDP Offer:------------------> ${offer.sdp}');

    socketService.emit('webrtc-offer', {
      'to': userId,
      'offer': {'sdp': offer.sdp, 'type': offer.type}
    });
  }

  MediaStream? getLocalStream() {
    return _localStream;
  }

  Future<void> setSpeakerMode(bool enable) async {
    try {
      MediaStreamTrack? audioTrack;
      _localStream?.getAudioTracks().forEach((track) {
        audioTrack = track;
      });

      if (audioTrack != null) {
        audioTrack!.enableSpeakerphone(enable);
        print("🔊 Altavoz ${enable ? 'activado' : 'desactivado'}");
      } else {
        print("❌ No se encontró pista de audio");
      }
    } catch (e) {
      print("❌ Error al cambiar el modo de audio: $e");
    }
  }


  Future<void> _setupPeerConnection() async {
    if (_peerConnection != null) return;

    _peerConnection = await createPeerConnection({
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'}, // Solo STUN
      ]
    });

    _localStream = await navigator.mediaDevices.getUserMedia({'audio': true});

    _localStream!.getTracks().forEach((track) {
      _peerConnection!.addTrack(track, _localStream!);
    });

    // ✅ Verifica que se están generando candidatos ICE válidos
    _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
      if (candidate.candidate != null) {
        print("📡 Enviando ICE Candidate: ${candidate.candidate}");
        socketService.emit('webrtc-candidate', {
          'candidate': {
            'candidate': candidate.candidate,
            'sdpMid': candidate.sdpMid,
            'sdpMLineIndex': candidate.sdpMLineIndex
          }
        });
      } else {
        print("⚠️ ICE Candidate vacío, ignorando.");
      }
    };

    _peerConnection!.onTrack = (RTCTrackEvent event) {
      if (onRemoteStream != null && event.streams.isNotEmpty) {
        print("📡 Recibiendo Stream Remoto: ${event.streams[0].id}");
        onRemoteStream!(event.streams[0]);
      }
    };
  }


  void handleIncomingCallEvents() {
    socketService.socket.on('webrtc-offer', (data) async {
      print("📩 Oferta WebRTC recibida: ${data['offer']}");

      if (data['offer'] == null || data['offer']['sdp'] == null) {
        print("❌ Error: La oferta WebRTC llegó vacía.");
        return;
      }

      RTCSessionDescription offer = RTCSessionDescription(
        data['offer']['sdp'],
        data['offer']['type'],
      );

      if (onIncomingCall != null) {
        onIncomingCall!(
            data['from'], offer); // ✅ Ahora enviamos la oferta correcta
      }
    });
  }







  Future<void> acceptCall(String callerId, RTCSessionDescription offer) async {
    print("📩 Aceptando llamada con SDP Offer: ${offer.sdp}");

    if (offer.sdp == null || offer.type == null) {
      print("❌ Error: SDP Offer es NULL o incompleta, abortando.");
      return;
    }

    await _setupPeerConnection();

    if (_peerConnection == null) {
      print(
          "❌ Error: _peerConnection es NULL después de _setupPeerConnection.");
      return;
    }

    await _peerConnection!.setRemoteDescription(offer);

    RTCSessionDescription answer = await _peerConnection!.createAnswer();
    await _peerConnection!.setLocalDescription(answer);

    socketService.emit('webrtc-answer', {
      'to': callerId,
      'answer': {'sdp': answer.sdp, 'type': answer.type}
    });
  }



  Future<void> endCall() async {
    _peerConnection?.close();
    _peerConnection = null;
    _localStream?.dispose();
  }
}
