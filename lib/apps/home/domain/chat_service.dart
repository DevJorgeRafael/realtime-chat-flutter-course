import 'package:flutter/material.dart';
import 'package:realtime_chat/config/constants/app_constants.dart';
import 'package:realtime_chat/models/mensajes_response.dart';

import 'package:realtime_chat/models/user.dart';
import 'package:realtime_chat/shared/service/dio_client.dart';

class ChatService with ChangeNotifier {
  final String url = AppConstants.baseAPIUrl;
  late User usuarioPara; 

  Future<List<Message>> getChat( String usuarioID ) async {
    try {
      final response = await DioClient.instance.get('/messages/$usuarioID');
      final messagesResponse = mensajesResponseFromJson( response.toString() );
      return messagesResponse.messages;
    } catch ( e ) {
      print( 'Error al obtener el chat: $e' );
      return [];
    }
  }

}