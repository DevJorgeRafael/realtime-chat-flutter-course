import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:realtime_chat/widgets/widgets.dart';

class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {

  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  final List<ChatMessage> _messages = [
    
  ];

  bool _estaEscribiendo = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Column(
          children: [
            CircleAvatar(
              child: Text('Ju', style: TextStyle(fontSize: 12), ),
              backgroundColor: Colors.red[100],
              maxRadius: 15,
            ),
            SizedBox(height: 3,),
            Text('Juan Guerra', style: TextStyle(color: Colors.black87, fontSize: 12),)
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

            Divider( height: 1, ), 

            //TODO: Caja de texto
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
        margin: EdgeInsets.symmetric( horizontal: 8 ),
        child: Row(
          children: [

            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (String texto) {
                  setState(() {
                    _estaEscribiendo = texto.trim().length > 0;
                  });
                },
                decoration: InputDecoration.collapsed(
                  hintText: 'Enviar mensaje'
                ),
                focusNode: _focusNode,
              ),
            ),

            //* Botón de enviar
            Container(
              margin: EdgeInsets.symmetric( horizontal: 4 ),
              child: Platform.isIOS ? 
              CupertinoButton(
                    child: Text('Enviar',
                        style: TextStyle(
                            color: _estaEscribiendo
                                ? Colors.red[400]
                                : CupertinoColors.inactiveGray)),
                    onPressed: _estaEscribiendo
                        ? () => _handleSubmit(_textController.text.trim())
                        : null,
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

    if (texto.length == 0) return;

    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(
      message: texto, 
      uid: '123', 
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 200)),  
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _estaEscribiendo = false;
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
