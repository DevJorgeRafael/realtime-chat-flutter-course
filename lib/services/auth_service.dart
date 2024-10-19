import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:realtime_chat/global/environment.dart';
import 'package:realtime_chat/models/login_response.dart';
import 'package:realtime_chat/models/usuario.dart';

class AuthService with ChangeNotifier {

  // Instancia de Dio
  final Dio _dio = Dio();
  late Usuario usuario;
  bool _autenticando = false;

  // Create storage
  final _storage = new FlutterSecureStorage();

  bool get autenticando => _autenticando;
  set autenticando( bool valor ) {
    _autenticando = valor;
    notifyListeners();
  }

  //Getters del token de forma estática
  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token ?? '';
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }


  Future<bool> login( String email, String password ) async {

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
        final loginResponse = loginResponseFromJson( res.toString() );
        usuario = loginResponse.usuario;

        await _guardarToken(loginResponse.token);

        autenticando = false;
        return true;
      } else {
        return false;
      }

    } catch (e) {
      print('Error en login: ');
      print(e);
      autenticando = false;
      return false;
    }
  }

  Future register(String nombre,  String email, String password ) async {
    autenticando = true;

    final data = {
      'nombre': nombre,
      'email': email,
      'password': password
    };
  
    try {
      final res = await _dio.post('${ Environment.apiUrl }/auth/register',
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json'
          }
        )
      );

      if(res.statusCode == 200) {
        final loginResponse = loginResponseFromJson( res.toString() );
        usuario = loginResponse.usuario;

        await _guardarToken(loginResponse.token);
        autenticando = false;
        return true;
        
      } else {
        return false;
      }
      
    } catch (e) {
      print('Error en registro: ');
      if( e is DioException ) {
        if( e.response != null ) {
          final errorResponse = e.response?.data;
          return errorResponse['msg'];
        }
      }
      autenticando = false;
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token');

    if( token == null ) {
      return false;
    }

    try {
      final res = await _dio.get('${Environment.apiUrl}/auth/renew',
          options: Options(headers: {
            'Content-Type': 'application/json',
            'x-token': token
          }));

      if (res.statusCode == 200) {
        final loginResponse = loginResponseFromJson(res.toString());
        usuario = loginResponse.usuario;
        await _guardarToken(loginResponse.token);

        autenticando = false;
        return true;
      } else {
        this.logout();
        return false;
      }
    } catch (e) {
      print('Error en isLoggedIn: ');
      if (e is DioException) {
        if (e.response != null) {
          final errorResponse = e.response?.data;
          return errorResponse['msg'];
        }
      }
      autenticando = false;
      return false;
    }
  } 


  Future _guardarToken( String token ) async {
    // Write value
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    await _storage.delete(key: 'token');
  }

}