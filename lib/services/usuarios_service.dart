import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';

import 'package:realtime_chat/global/environment.dart';
import 'package:realtime_chat/models/user.dart';
import 'package:realtime_chat/models/users_response.dart';

import 'package:realtime_chat/services/auth_service.dart';

class UsuariosService with ChangeNotifier{

  Future<List<User>> getUsuarios () async {
    try {
      final response = await dio.Dio().get('${ Environment.apiUrl }/users', 
        options: dio.Options(
          headers: {
            'Content-type': 'application/json',
            'x-token': await AuthService.getToken()
            }
        )
      );

      final usuarios = usersResponseFromjson( response.data );
      return usuarios;
    } catch (e) {
      print('Error al obtener usuarios: \n $e');
      return [];
    }

  }

}