import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:realtime_chat/global/environment.dart';
import 'package:realtime_chat/models/mensajes_response.dart';

import 'package:realtime_chat/models/user.dart';
import 'package:realtime_chat/services/services.dart';

class ChatService with ChangeNotifier {

  late User usuarioPara; 

  Future<List<Message>> getChat( String usuarioID ) async {
    try {
      final response = await dio.Dio().get(
        '${Environment.apiUrl}/messages/$usuarioID',
        options: dio.Options(
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken(),
          },
        ),
      );

      final messagesResponse = mensajesResponseFromJson( response.toString() );
      // print( messagesResponse.messages );
      return messagesResponse.messages;
    } catch ( e ) {
      print( 'Error al obtener el chat: $e' );
      return [];
    }
  }

}