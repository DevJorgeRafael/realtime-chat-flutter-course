import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtime_chat/services/services.dart';

class ChatMessage extends StatelessWidget {

  final String message;
  final String uid;
  final AnimationController animationController;

  const ChatMessage({
    super.key, 
    required this.message, 
    required this.uid,
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        child: Container(
          child: uid == authService.usuario.uid 
            ? _myMessage()
            : _notMyMessage(),
        ),
      ),
    );
  }

  Widget _myMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all( 8 ),
        margin: const EdgeInsets.only(
          bottom: 5,
          left: 50,
          right: 5
        ),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(20)
        ),
        child: Text( message, style: const TextStyle(color: Colors.white), ),
      ),
    );
  }

  Widget _notMyMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(bottom: 5, left: 5, right: 50),
        decoration: BoxDecoration(
            color: const Color(0xffE4E5E8),
            borderRadius: BorderRadius.circular(20)),
        child: Text(
          message,
          style: const TextStyle(color: Colors.black87),
        ),
      ),
    );
  }
}
