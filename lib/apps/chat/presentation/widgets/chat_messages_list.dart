import 'package:flutter/material.dart';
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
  final ScrollController _scrollController =
      ScrollController(); // 👈 Controlador de Scroll

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controllers.clear();
    for (var i = 0; i < widget.messages.length; i++) {
      _controllers.add(_createAnimationController());
    }
  }

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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom(); // 👈 Mover el scroll al final después de actualizar
      });

      for (var i = _controllers.length; i < widget.messages.length; i++) {
        _controllers.insert(0, _createAnimationController());
      }
    }
  }

  /// **Método para mover el scroll al final**
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _scrollController.dispose(); // Liberar el controlador de scroll
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController, // 👈 Asignar el controlador de scroll
      physics: const BouncingScrollPhysics(),
      itemCount: widget.messages.length,
      reverse: true,
      itemBuilder: (BuildContext context, int index) {
        return ChatMessageWidget(
          message: widget.messages[index],
          animationController: _controllers[index],
        );
      },
    );
  }
}
