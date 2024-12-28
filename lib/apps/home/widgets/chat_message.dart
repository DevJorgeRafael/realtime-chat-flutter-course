import 'package:flutter/material.dart';
import 'package:realtime_chat/apps/auth/domain/auth_service.dart';
import 'package:realtime_chat/injection_container.dart';
import 'package:realtime_chat/shared/utils/abrir_enlace_util.dart';

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
    final authService = sl<AuthService>();

    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor:
            CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        child: _buildMessage(
          context: context,
          isMine: uid == authService.user.id,
          message: message,
        ),
      ),
    );
  }

  Widget _buildMessage({
    required BuildContext context,
    required bool isMine,
    required String message,
  }) {
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: EdgeInsets.only(
          bottom: 5,
          left: isMine ? 50 : 5,
          right: isMine ? 5 : 50,
        ),
        decoration: BoxDecoration(
          color: isMine ? Colors.red.shade400 : const Color(0xffE4E5E8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: GestureDetector(
          onTap: () => _handleTap(context, message),
          child: Text(
            message,
            style: TextStyle(
              color: _isLink(message) ? ( isMine? Colors.blue.shade200 : Colors.blue ) : ( isMine? Colors.white : Colors.black87 ),
              
              decoration: _isLink(message)
                  ? TextDecoration.underline
                  : TextDecoration.none,
              decorationColor: isMine? Colors.blue.shade200: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }

  bool _isLink(String text) {
    final Uri? uri = Uri.tryParse(text);
    return uri != null && (uri.hasScheme || uri.host.isNotEmpty);
  }

  void _handleTap(BuildContext context, String text) async {
    if (_isLink(text)) {
      await abrirEnlaceUtil(context, text);
    }
  }
}
