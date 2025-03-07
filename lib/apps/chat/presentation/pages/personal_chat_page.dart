import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:realtime_chat/apps/auth/domain/auth_service.dart';
import 'package:realtime_chat/apps/chat/domain/call_service.dart';
import 'package:realtime_chat/apps/chat/domain/chat_service.dart';
import 'package:realtime_chat/apps/chat/domain/socket_service.dart';
import 'package:realtime_chat/apps/chat/helpers/insert_message_helpers.dart';
import 'package:realtime_chat/apps/chat/models/messages_response.dart';
import 'package:realtime_chat/apps/chat/presentation/pages/incoming_call_page.dart';
import 'package:realtime_chat/apps/chat/presentation/widgets/chat_input_field.dart';
import 'package:realtime_chat/apps/chat/presentation/widgets/chat_message_widget.dart';
import 'package:realtime_chat/apps/chat/presentation/widgets/personal_chat_appbar.dart';
import 'package:realtime_chat/injection_container.dart';

class PersonalChatPage extends StatefulWidget {
  const PersonalChatPage({super.key});

  @override
  State<PersonalChatPage> createState() => _PersonalChatPageState();
}

class _PersonalChatPageState extends State<PersonalChatPage>
    with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  final List<ChatMessageWidget> _messages = [];

  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;
  late CallService callService;

  @override
  void initState() {
    super.initState();
    chatService = sl<ChatService>();
    socketService = sl<SocketService>();
    authService = sl<AuthService>();
    callService = CallService();

    socketService.socket.on('mensaje-personal', _escucharMensaje);
    callService.handleIncomingCallEvents();

  // Manejo de llamadas entrantes
  callService.onIncomingCall = (callerId, offer) {
      // ✅ Ahora sí funciona correctamente
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => IncomingCallPage(
            callerId: callerId,
            callService: callService,
            offer: offer, // ✅ Ahora sí se pasa correctamente la oferta SDP
          ),
        ),
      );
    };



    _cargarHistorial();
  }

  void _updateMessages(List<ChatMessageWidget> messages) {
    setState(() {
      _messages.clear();
      _messages.addAll(messages);
    });
  }

  @override
  Widget build(BuildContext context) {
    final usuarioPara = chatService.userReceiver;

    return Scaffold(
      appBar: PersonalChatAppbar(user: usuarioPara),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: _messages.length,
              reverse: true,
              itemBuilder: (BuildContext context, int index) {
                return _messages[index];
              },
            ),
          ),
          const Divider(height: 1),
          ChatInputField(
            onSendMessage: _handleSubmit,
            messages: _messages, 
            vsync: this, 
            updateMessages:
                _updateMessages,
          ),

        ],
      ),
    );
  }

  void _cargarHistorial() async {
    await chatService.loadChatHistory(chatService.userReceiver.id);
    List<Message> chat = chatService.messages.reversed.toList();

    if (!mounted) return;

    setState(() {
      _messages.clear();
    });

    for (var message in chat) {
      if (message.type == "image" &&
          message.fileId != null &&
          !message.isFileDownloaded) {
        String? filePath = await message.fetchFileIfNeeded();
        if (filePath != null) {
          message.fileUrl = filePath; 
        }
      }

      if (!mounted) return;

      setState(() {
        InsertMessageHelper.insertMessage(
          message: message,
          messages: _messages,
          vsync: this,
          updateMessages: _updateMessages,
        );
      });
    }
  }

  void _handleSubmit(String texto) {
    if (texto.isEmpty) return;

    _textController.clear();
    _focusNode.requestFocus();

    InsertMessageHelper.insertTextMessage(
      text: texto,
      userId: authService.user.id,
      receiverId: chatService.userReceiver.id,
      messages: _messages,
      vsync: this,
      updateMessages: _updateMessages,
    );

    socketService.emit('mensaje-personal', {
      'from': authService.user.id,
      'to': chatService.userReceiver.id,
      'message': texto,
      'type': 'text',
      'fileUrl': null,
    });
  }

  void _escucharMensaje(dynamic payload) {
    try {
      print("📩 Mensaje recibido del socket: ${jsonEncode(payload)}"); // 🔍 Depuración completa

      final receivedMessage = Message.fromJson(payload);

      InsertMessageHelper.insertMessage(
        message: receivedMessage,
        messages: _messages,
        vsync: this,
        updateMessages: _updateMessages,
      );
    } catch (e, stacktrace) {
      print("❌ Error al procesar el mensaje: $e");
      print("📝 Stacktrace: $stacktrace"); // 📌 Muestra dónde exactamente falló
    }
  }


  @override
  void dispose() {
    socketService.socket.off('mensaje-personal');
    super.dispose();
  }
}
