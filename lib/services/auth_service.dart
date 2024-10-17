import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:realtime_chat/global/environment.dart';
import 'package:realtime_chat/models/login_response.dart';
import 'package:realtime_chat/models/usuario.dart';

class AuthService with ChangeNotifier {

  // Instancia de Dio
  final Dio _dio = Dio();
  late Usuario usuario;


  Future login( String email, String password ) async {

    final data = {
      'email': email,
      'password': password
    };

    try {
      final res = await _dio.post('${ Environment.apiUrl }/auth/login',
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json'
          }
        )
      );



      print(res.data);
      if(res.statusCode == 200) {
        final loginresponse = loginResponseFromJson( res.toString() );
        usuario = loginresponse.usuario;
        print(usuario.nombre);
      }


      return res;

    } catch (e) {
      print('Error en login: ');
      print(e);

      return false;
    }

    

  }

}