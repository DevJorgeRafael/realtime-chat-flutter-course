import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:realtime_chat/global/environment.dart';
import 'package:realtime_chat/models/login_response.dart';
import 'package:realtime_chat/models/usuario.dart';

class AuthService with ChangeNotifier {

  // Instancia de Dio
  final Dio _dio = Dio();
  late Usuario usuario;
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

      if(res.statusCode == 200) {
        final loginResponse = loginResponseFromJson( res.toString() );
        usuario = loginResponse.usuario;

        await _guardarToken(loginResponse.token);
        await _guardarUsuario(loginResponse.usuario);

        autenticando = false;
        return {'ok': 'true'};
      } else {
        return {'ok': 'false', 'msg': 'Credenciales incorrectas'};
      }

    } catch (e) {
      print('Error en login: $e');
      autenticando = false;

      if (e is DioException) {
        final response = e.response;
        if (response != null && response.data != null ) {
          return {
            'ok': 'false',
            'msg': response.data['msg'] ?? 'Error desconocido'
          };
        }
      }
      return {'ok': 'false', 'msg': 'Error en el servidor'};
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

  Future<bool> isLoggedIn(BuildContext context) async {

    final token = await _storage.read(key: 'token');
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('usuario');

    if( token == null || userData == null ) {
      logout();
      return false;
    }

    try {
      usuario = Usuario.fromJson(jsonDecode(userData));
      print("usuario cargado desde local. ------ $usuario");
      return true;
    } catch (e) {
      await logout();
      return false;
    }
  } 

  Future<void> _guardarUsuario(Usuario usuario) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = jsonEncode(usuario.toJson());
    await prefs.setString('usuario', userData);
  }

  Future<Usuario?> cargarUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('usuario');
    if( userData != null ) {
      return Usuario.fromJson(jsonDecode(userData));
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