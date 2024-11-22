import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';

import 'package:realtime_chat/global/environment.dart';
import 'package:realtime_chat/models/usuario.dart';
import 'package:realtime_chat/models/usuarios_response.dart';

import 'package:realtime_chat/services/auth_service.dart';

class UsuariosService with ChangeNotifier{

  Future<List<Usuario>> getUsuarios () async {

    try {
      final response = await dio.Dio().get('${ Environment.apiUrl }/usuarios', 
        options: dio.Options(
          headers: {
            'Content-type': 'application/json',
            'x-token': await AuthService.getToken()
            }
        )
      );

      final usuariosResponse = usuariosResponseFromJson( response.toString() );
      return usuariosResponse.usuarios;
    } catch (e) {
      print('Error al obtener usuarios: \n $e');
      return [];
    }

  }

}