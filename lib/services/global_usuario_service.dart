import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:realtime_chat/models/usuario.dart';
import 'package:flutter/material.dart';

class GlobalUsuarioService with ChangeNotifier {
  Usuario? _usuario;

  Usuario? get usuario => _usuario;

  Future<void> guardarUsuario(Usuario usuario) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = jsonEncode(usuario.toJson());
    await prefs.setString('usuario', userData);
    _usuario = usuario;
    notifyListeners();
  }

  Future<void> cargarUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('usuario');
    if (userData != null) {
      _usuario = Usuario.fromJson(jsonDecode(userData));
      notifyListeners();
    }
  }

  Future<void> eliminarUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('usuario');
    _usuario = null;
    notifyListeners();
  }
}
