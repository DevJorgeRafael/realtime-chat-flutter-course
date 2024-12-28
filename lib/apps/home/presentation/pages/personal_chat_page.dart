import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:realtime_chat/apps/auth/domain/auth_service.dart';
import 'package:realtime_chat/apps/home/domain/chat_service.dart';
import 'package:realtime_chat/apps/home/domain/socket_service.dart';
import 'package:realtime_chat/apps/home/widgets/chat_message.dart';
import 'package:realtime_chat/apps/home/helpers/chat_helpers.dart';
import 'package:realtime_chat/injection_container.dart';
import 'package:realtime_chat/apps/home/models/mensajes_response.dart';
import 'package:realtime_chat/shared/models/user.dart';

class PersonalChatPage extends StatefulWidget {
  const PersonalChatPage({super.key});

  @override
  State<PersonalChatPage> createState() => _PersonalChatPageState();
}

class _PersonalChatPageState extends State<PersonalChatPage>
    with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  final List<ChatMessage> _messages = [];
  bool _estaEscribiendo = false;

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
    _cargarHistorial(chatService.userReceiver.id);
  }

  @override
  Widget build(BuildContext context) {
    final usuarioPara = chatService.userReceiver;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: _buildAppBarTitle(usuarioPara),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) =>
                  _messages[index],
              reverse: true,
            ),
          ),
          const Divider(height: 1),
          _inputChat(),
        ],
      ),
    );
  }

  Widget _buildAppBarTitle(User usuarioPara) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.red[100],
          maxRadius: 15,
          child: Text(usuarioPara.name.substring(0, 2),
              style: const TextStyle(fontSize: 12)),
        ),
        const SizedBox(height: 3),
        Text(usuarioPara.name,
            style: const TextStyle(color: Colors.black87, fontSize: 12)),
      ],
    );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            // Campo de texto
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (texto) =>
                    setState(() => _estaEscribiendo = texto.trim().isNotEmpty),
                decoration:
                    const InputDecoration.collapsed(hintText: 'Mensaje'),
                focusNode: _focusNode,
              ),
            ),

            // Íconos de acción o botón de enviar
            _estaEscribiendo ? _buildSendIcon() : _buildActionIcons(),
          ],
        ),
      ),
    );
  }

// Botón de enviar
  Widget _buildSendIcon() {
    return IconButton(
      icon: const Icon(Icons.send, color: Colors.red),
      onPressed: () =>
          _estaEscribiendo ? _handleSubmit(_textController.text.trim()) : null,
    );
  }

  Widget _buildActionIcons() {
    return const Row(
      children: [
        IconButton(
            icon: Icon(Icons.mic, color: Colors.grey),
            onPressed: handleAudioAction),
        IconButton(
            icon: Icon(Icons.photo, color: Colors.grey),
            onPressed: handleGalleryAction),
        IconButton(
            icon: Icon(Icons.photo_camera, color: Colors.grey),
            onPressed: handleCameraAction),
        IconButton(
            icon: Icon(Icons.attach_file, color: Colors.grey),
            onPressed: handleAttachFileAction),
      ],
    );
  }

  void _handleSubmit(String texto) {
    if (texto.isEmpty) return;

    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(
      message: texto,
      uid: authService.user.id,
      animationController: AnimationController(
          vsync: this, duration: const Duration(milliseconds: 200)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() => _estaEscribiendo = false);

    socketService.emit('mensaje-personal', {
      'from': authService.user.id,
      'to': chatService.userReceiver.id,
      'message': texto,
    });
  }

  void _cargarHistorial(String usuarioID) async {
    List<Message> chat = await chatService.getChat(usuarioID);
    final history = chat.map((m) => ChatMessage(
          message: m.message,
          uid: m.from,
          animationController: AnimationController(
              vsync: this, duration: const Duration(milliseconds: 300))
            ..forward(),
        ));

    if (!mounted) return;

    setState(() => _messages.insertAll(0, history));
  }

  void _escucharMensaje(dynamic payload) {
    ChatMessage message = ChatMessage(
      message: payload['message'],
      uid: payload['from'],
      animationController: AnimationController(
          vsync: this, duration: const Duration(milliseconds: 300)),
    );

    setState(() => _messages.insert(0, message));
    message.animationController.forward();
  }

  @override
  void dispose() {
    socketService.socket.off('mensaje-personal');
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}
