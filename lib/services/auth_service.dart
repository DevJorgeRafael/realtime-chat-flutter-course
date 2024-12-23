import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:realtime_chat/global/environment.dart';
import 'package:realtime_chat/models/login_response.dart';
import 'package:realtime_chat/models/user.dart';

class AuthService with ChangeNotifier {

  // Instancia de Dio
  final Dio _dio = Dio();
  late User user;
  bool _autenticando = false;

  // Create storage
  final _storage = const FlutterSecureStorage();

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


  Future<Map<String, dynamic>> login( String email, String password ) async {
    autenticando = true;

    final data = {
      'email': email,
      'password': password
    };

    try {
      final res = await _dio.post(
        '${ Environment.apiUrl }/auth/login',
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json'
          }
        )
      );

      print('Código de estadoooooo: ${res.statusCode}');
      if(res.statusCode == 200) {
        final loginResponse = loginResponseFromJson( res.toString() );
        user = loginResponse.user;

        await _guardarToken(loginResponse.token);
        await _guardarUsuario(loginResponse.user);

        autenticando = false;
        return {'ok': 'true'};
      } else {
        autenticando = false;
        return {'ok': 'false', 'message': 'Error desconocido'};
      }

    } catch (e) {
      print('Error en login: $e');
      autenticando = false;

      if (e is DioException) {
        final response = e.response;

        if (response != null ) {
          return {
            'ok': 'false',
            'message': response.data['message'] ?? 'Error desconocido'
          };
        }

        if ( response?.statusCode == 503 ) {
          return {
            'ok': 'false',
            'message': 'Servidor no disponible'
          };
        }
        
      }
      return {'ok': 'false', 'message': 'Error en el servidor'};
    }
  }

  Future<String?> register(String nombre,  String email, String password ) async {
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
        user = loginResponse.user;

        await _guardarToken(loginResponse.token);
        autenticando = false;
        return null;
        
      } else {
        return 'Error desconocido';
      }
      
    } catch (e) {
      print('Error en registro: $e');
      autenticando = false;

      if( e is DioException ) {
        if( e.response != null ) {
          final errorResponse = e.response?.data;
          return errorResponse['message'] ?? 'Error desconocido';
        }
      }
      return 'Error en el servidor';
    }
  }

  Future<bool> isLoggedIn(BuildContext context) async {

    final token = await _storage.read(key: 'token');
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('usuario');

    if( token == null || userData == null ) {
      logout();
      return false;
    }

    try {
      user = User.fromJson(jsonDecode(userData));
      return true;
    } catch (e) {
      await logout();
      return false;
    }
  } 

  Future<void> _guardarUsuario(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = jsonEncode(user.toJson());
    await prefs.setString('usuario', userData);
  }

  Future<User?> cargarUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('usuario');
    if( userData != null ) {
      return User.fromJson(jsonDecode(userData));
    }
    return null;
  }

  Future _guardarToken( String token ) async {
    // Write value
    return await _storage.write(key: 'token', value: token);
  }

  static Future logout() async {
    await deleteToken();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('usuario');
  }

}