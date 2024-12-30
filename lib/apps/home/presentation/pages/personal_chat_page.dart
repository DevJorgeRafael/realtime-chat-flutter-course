import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:realtime_chat/apps/auth/domain/auth_service.dart';
import 'package:realtime_chat/apps/home/domain/chat_service.dart';
import 'package:realtime_chat/apps/home/domain/socket_service.dart';
import 'package:realtime_chat/apps/home/widgets/chat_message.dart';
import 'package:realtime_chat/apps/home/helpers/chat_helpers.dart';
import 'package:realtime_chat/injection_container.dart';
import 'package:realtime_chat/apps/home/models/messages_response.dart';
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
  bool isRecording = false;

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
        backgroundColor: Colors.red,
        elevation: 1,
        title: _buildAppBarTitle(usuarioPara),
        iconTheme: const IconThemeData(color: Colors.white),
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
    return Row(
      children: [
        const Icon(Icons.account_circle, color: Colors.white, size: 42,),
        const SizedBox(width: 3),
        Text(usuarioPara.name,
            style: const TextStyle(color: Colors.white, fontSize: 16)),
        const Spacer(),
        const Icon(Icons.call, color: Colors.white, size: 24),
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
    return Row(
      children: [
        GestureDetector(
          onLongPress: () async {
            setState(() => isRecording = true);
            await handleAudioStart(context);
          },
          onLongPressUp: () async {
            setState(() => isRecording = false);
            final audioPath = await handleAudioStop(context);

            if (audioPath != null) {
              final newMessage = ChatMessage(
                audioUrl: audioPath, // Ruta del archivo de audio
                uid: authService.user.id,
                animationController: AnimationController(
                  vsync: this,
                  duration: const Duration(milliseconds: 200),
                ),
              );

              setState(() {
                _messages.insert(0, newMessage);
              });

              newMessage.animationController.forward();
            }
          },
          child: Icon(
            Icons.mic,
            color: isRecording ? Colors.red : Colors.grey,
            size: isRecording ? 48 : 24,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.photo, color: Colors.grey),
          onPressed: () => handleGalleryAction(context),
        ),
        IconButton(
          icon: const Icon(Icons.photo_camera, color: Colors.grey),
          onPressed: () => handleCameraAction(context),
        ),
        IconButton(
          icon: const Icon(Icons.attach_file, color: Colors.grey),
          onPressed: () => handleAttachFileAction(context, (filePath, fileName) {
            _insertFileMessage(filePath, fileName);
          }),
        ),
      ],
    );
  }

  void _insertFileMessage(String filePath, String fileName) {
    final newMessage = ChatMessage(
      uid: authService.user.id,
      filePath: filePath,
      fileName: fileName,
      animationController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      )..forward(),
    );

    setState(() => _messages.insert(0, newMessage));
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
      'type': 'text',
      'fileUrl': null,
    });
  }

  void _cargarHistorial(String usuarioID) async {
    // Obtener los mensajes del servicio
    List<Message> chat = await chatService.getChat(usuarioID);

    // Mapear los mensajes al widget `ChatMessage`
    final history = chat.map((m) {
      if (m.type == "text") {
        // Si el mensaje es de tipo texto
        return ChatMessage(
          message: m.message ?? "", // Mostrar texto del mensaje
          uid: m.from,
          animationController: AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 300),
          )..forward(),
        );
      } else if (m.type == "audio") {
        // Si el mensaje es de tipo audio
        return ChatMessage(
          audioUrl: m.fileUrl, // URL del archivo de audio
          uid: m.from,
          animationController: AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 300),
          )..forward(),
        );
      } else if (m.type == "image") {
        // Si el mensaje es de tipo imagen
        return ChatMessage(
          imageUrl: m.fileUrl, // URL de la imagen
          uid: m.from,
          animationController: AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 300),
          )..forward(),
        );
      } else if (m.type == "video") {
        // Si el mensaje es de tipo video
        return ChatMessage(
          videoUrl: m.fileUrl, // URL del archivo de video
          uid: m.from,
          animationController: AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 300),
          )..forward(),
        );
      } else {
        // Tipo no soportado, muestra un mensaje genérico
        return ChatMessage(
          message: "Mensaje no soportado",
          uid: m.from,
          animationController: AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 300),
          )..forward(),
        );
      }
    }).toList();

    // Verificar si el widget sigue montado
    if (!mounted) return;

    // Actualizar la lista de mensajes en el estado
    setState(() => _messages.insertAll(0, history));
  }


  void _escucharMensaje(dynamic payload) {
    final type = payload['type']; // Determinar el tipo de mensaje
    final fileUrl = payload['fileUrl'];

    ChatMessage message;

    if (type == 'text') {
      message = ChatMessage(
        message: payload['message'],
        uid: payload['from'],
        animationController: AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 300),
        ),
      );
    } else if (type == 'audio') {
      message = ChatMessage(
        audioUrl: fileUrl,
        uid: payload['from'],
        animationController: AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 300),
        ),
      );
    } else if (type == 'image') {
      message = ChatMessage(
        imageUrl: fileUrl,
        uid: payload['from'],
        animationController: AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 300),
        ),
      );
    } else if (type == 'video') {
      message = ChatMessage(
        videoUrl: fileUrl,
        uid: payload['from'],
        animationController: AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 300),
        ),
      );
    } else {
      message = ChatMessage(
        message: "Mensaje no soportado",
        uid: payload['from'],
        animationController: AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 300),
        ),
      );
    }

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
