import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:realtime_chat/apps/chat/models/messages_response.dart';
import 'package:realtime_chat/apps/chat/presentation/widgets/chat_message_widget.dart';

class ChatMessagesList extends StatefulWidget {
  final List<Message> messages;

  const ChatMessagesList({super.key, required this.messages});

  @override
  State<ChatMessagesList> createState() => _ChatMessagesListState();
}

class _ChatMessagesListState extends State<ChatMessagesList>
    with TickerProviderStateMixin {
  final List<AnimationController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  /// **Inicializa las animaciones para los mensajes existentes**
  void _initializeAnimations() {
    _controllers.clear();
    for (var i = 0; i < widget.messages.length; i++) {
      _controllers.add(_createAnimationController());
    }
  }

  /// **Crea un nuevo `AnimationController` y lo devuelve**
  AnimationController _createAnimationController() {
    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    controller.forward();
    return controller;
  }

  @override
  void didUpdateWidget(covariant ChatMessagesList oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.messages.length > oldWidget.messages.length) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        for (var i = _controllers.length; i < widget.messages.length; i++) {
          _controllers.insert(0, _createAnimationController());
        }
      });
    }
  }


  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: widget.messages.length,
      reverse: true,
      itemBuilder: (BuildContext context, int index) {
        return ChatMessageWidget(
          message: widget.messages[index],
          animationController: _controllers[index], // 🔥 Ahora siempre existe
        );
      },
    );
  }
}
