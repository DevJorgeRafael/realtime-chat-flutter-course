import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:realtime_chat/apps/auth/domain/auth_service.dart';
import 'package:realtime_chat/apps/chat/domain/chat_service.dart';
import 'package:realtime_chat/apps/chat/domain/socket_service.dart';
import 'package:realtime_chat/apps/chat/helpers/insert_message_helpers.dart';
import 'package:realtime_chat/apps/chat/models/messages_response.dart';
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

  @override
  void initState() {
    super.initState();
    chatService = sl<ChatService>();
    socketService = sl<SocketService>();
    authService = sl<AuthService>();

    socketService.socket.on('mensaje-personal', _escucharMensaje);
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
            onSendFile: (filePath) {
              InsertMessageHelper.insertFileMessage(
                filePath: filePath,
                fileName: "Archivo",
                userId: authService.user.id,
                receiverId: chatService.userReceiver.id,
                messages: _messages,
                vsync: this,
                updateMessages: _updateMessages,
              );
            },
          ),
        ],
      ),
    );
  }

  void _cargarHistorial() async {
    await chatService.loadChatHistory(chatService.userReceiver.id);
    List<Message> chat = chatService.messages;
    if (!mounted) return;

    setState(() {
      _messages.clear();
      for (var message in chat) {
        InsertMessageHelper.insertMessage(
          message: message,
          messages: _messages,
          vsync: this,
          updateMessages: _updateMessages,
        );
      }
    });
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
    final receivedMessage = Message.fromJson(payload);

    InsertMessageHelper.insertMessage(
      message: receivedMessage,
      messages: _messages,
      vsync: this,
      updateMessages: _updateMessages,
    );
  }

  @override
  void dispose() {
    socketService.socket.off('mensaje-personal');
    super.dispose();
  }
}
