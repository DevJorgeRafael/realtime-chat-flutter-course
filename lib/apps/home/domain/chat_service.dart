import 'package:flutter/material.dart';
import 'package:realtime_chat/config/constants/app_constants.dart';
import 'package:realtime_chat/apps/home/models/mensajes_response.dart';

import 'package:realtime_chat/shared/models/user.dart';
import 'package:realtime_chat/shared/service/dio_client.dart';

class ChatService with ChangeNotifier {
  final String url = AppConstants.baseAPIUrl;
  late User userReceiver; 

  Future<List<Message>> getChat( String userId ) async {
    try {
      final response = await DioClient.instance.get('/messages/$userId');
      final messagesResponse = mensajesResponseFromJson( response.toString() );
      return messagesResponse.messages;
    } catch ( e ) {
      print( 'Error al obtener el chat: $e' );
      return [];
    }
  }

}