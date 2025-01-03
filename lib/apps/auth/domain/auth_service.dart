import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:realtime_chat/shared/service/dio_client.dart';
import 'package:realtime_chat/shared/utils/safe_change_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:realtime_chat/apps/auth/models/login_response.dart';
import 'package:realtime_chat/shared/models/user.dart';

class AuthService extends SafeChangeNotifier {
  late User user;
  bool _authenticating = false;

  // Create storage
  final _storage = const FlutterSecureStorage();

  bool get authenticating => _authenticating;
  set authenticating( bool valor ) {
    _authenticating = valor;
    notifyListeners();
  }

  //Getters del token de forma estática
  static Future<String> getToken() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    return token ?? '';
  }

  static Future<void> deleteToken() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'token');
  }


  Future<Map<String, dynamic>> login( String email, String password ) async {
    authenticating = true;

    final data = {
      'email': email,
      'password': password
    };

    try {
      final res = await DioClient.instance.post(
        '/auth/login',
        data: data,
      );

      if(res.statusCode == 200) {
        final loginResponse = loginResponseFromJson( res.toString() );
        user = loginResponse.user;

        await _saveToken(loginResponse.token);
        await _saveUser(loginResponse.user);

        authenticating = false;
        return {'ok': 'true'};
      } else {
        authenticating = false;
        return {'ok': 'false', 'message': 'Error desconocido'};
      }

    } catch (e) {
      print('Error en login: $e');
      authenticating = false;

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
    authenticating = true;

    final data = {
      'name': nombre,
      'email': email,
      'password': password
    };
  
    try {
      final res = await DioClient.instance.post(
        '/auth/register',
        data: data,
      );

      if(res.statusCode == 201) {
        final loginResponse = loginResponseFromJson( res.toString() );
        user = loginResponse.user;

        await _saveToken(loginResponse.token);
        authenticating = false;
        return null;
        
      } else {
        return 'Error desconocido';
      }
      
    } catch (e) {
      print('Error en registro: $e');
      authenticating = false;

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

  Future<void> _saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = jsonEncode(user.toJson());
    await prefs.setString('usuario', userData);
  }

  Future<User?> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('usuario');
    if( userData != null ) {
      return User.fromJson(jsonDecode(userData));
    }
    return null;
  }

  Future _saveToken( String token ) async {
    // Write value
    return await _storage.write(key: 'token', value: token);
  }

  static Future logout() async {
    await deleteToken();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('usuario');
  }
}