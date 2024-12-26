import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:realtime_chat/apps/auth/domain/auth_service.dart';
import 'package:realtime_chat/apps/home/domain/chat_service.dart';
import 'package:realtime_chat/apps/home/domain/socket_service.dart';
import 'package:realtime_chat/injection_container.dart';
import 'package:realtime_chat/widgets/widgets.dart';
import 'package:realtime_chat/models/mensajes_response.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {

  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;

  final List<ChatMessage> _messages = [];

  bool _estaEscribiendo = false;

  @override
  void initState() {
    super.initState();
    chatService = sl<ChatService>();
    socketService = sl<SocketService>();
    authService = sl<AuthService>();

    socketService.socket.on('mensaje-personal', _escucharMensaje);

    _cargarHistorial( chatService.usuarioPara.id );
  }

  void _cargarHistorial( String usuarioID ) async {

    List<Message> chat = await chatService.getChat(usuarioID);

    final history = chat.map((m) => ChatMessage(
      message: m.message,
      uid: m.from,
      animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 300))..forward(),
    ));

    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _escucharMensaje( dynamic payload ) {
    ChatMessage message = ChatMessage(
      message: payload['message'], 
      uid: payload['from'], 
      animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 300 )),
    );

    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {

    final usuarioPara = chatService.usuarioPara;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.red[100],
              maxRadius: 15,
              child: Text(usuarioPara.name.substring(0, 2), style: const TextStyle(fontSize: 12), ),
            ),
            const SizedBox(height: 3,),
            Text( usuarioPara.name, style: const TextStyle(color: Colors.black87, fontSize: 12),)
          ],
        ),
        centerTitle: true,
      ),

      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: (BuildContext context, int index) {
                  return _messages[index];
                },
                reverse: true,
              ),
            ), 

            const Divider( height: 1, ), 

            Container(
              color: Colors.white,
              child: _inputChat(),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric( horizontal: 8 ),
        child: Row(
          children: [

            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (String texto) {
                  setState(() {
                    _estaEscribiendo = texto.trim().isNotEmpty;
                  });
                },
                decoration: const InputDecoration.collapsed(
                  hintText: 'Enviar mensaje'
                ),
                focusNode: _focusNode,
              ),
            ),

            //* Botón de enviar
            Container(
              margin: const EdgeInsets.symmetric( horizontal: 4 ),
              child: Platform.isIOS ? 
              CupertinoButton(
                    onPressed: _estaEscribiendo
                        ? () => _handleSubmit(_textController.text.trim())
                        : null,
                    child: Text('Enviar',
                        style: TextStyle( color: _estaEscribiendo ? Colors.red[400] : CupertinoColors.inactiveGray)),
                  )
              : Container(
                margin: const EdgeInsets.symmetric( horizontal: 4 ),
                child: IconTheme(
                  data: IconThemeData( color: _estaEscribiendo ? Colors.red[400] : Colors.grey ),
                  child: IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    icon: const Icon( Icons.send ),
                    onPressed: () => _estaEscribiendo
                      ? _handleSubmit( _textController.text.trim() )
                      : null,
                  ),
                ),
              ),
            )


          ],
        ),
      )
    );

  }

  _handleSubmit(String texto) {

    if (texto.isEmpty) return;

    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(
      message: texto, 
      uid: authService.user.id, 
      animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 200)),  
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _estaEscribiendo = false;
    });

    socketService.emit('mensaje-personal', {
      'from': authService.user.id,
      'to': chatService.usuarioPara.id,
     'message': texto
    });
  }

  @override
  void dispose() {
    //TODO: off del socket

    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }

    super.dispose();
  }
}
