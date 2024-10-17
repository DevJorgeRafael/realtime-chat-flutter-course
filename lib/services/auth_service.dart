import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:realtime_chat/global/environment.dart';
import 'package:realtime_chat/models/login_response.dart';
import 'package:realtime_chat/models/usuario.dart';

class AuthService with ChangeNotifier {

  // Instancia de Dio
  final Dio _dio = Dio();
  late Usuario usuario;
  bool _autenticando = false;

  bool get autenticando => _autenticando;
  set autenticando( bool valor ) {
    _autenticando = valor;
    notifyListeners();
  }


  Future login( String email, String password ) async {

    autenticando = true;

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


      if(res.statusCode == 200) {
        final loginresponse = loginResponseFromJson( res.toString() );
        usuario = loginresponse.usuario;
      }

      autenticando = false;
      print('------------------------------' + res.toString());
      print(autenticando);
      return res;

    } catch (e) {
      print('Error en login: ');
      print(e);
      autenticando = false;
      return false;
    }

  }
}