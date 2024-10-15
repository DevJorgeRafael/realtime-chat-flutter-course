import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {

  final String message;
  final String uid;

  const ChatMessage({
    super.key, 
    required this.message, 
    required this.uid
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: this.uid == '123'
        ? _myMessage()
        : _notMyMessage(),
    );
  }

  Widget _myMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.all( 8 ),
        child: Text( message ),
        decoration: BoxDecoration(
          color: Colors.red.shade400
        ),
      ),
    );
  }

  Widget _notMyMessage() {

    return Container();
  }
}
