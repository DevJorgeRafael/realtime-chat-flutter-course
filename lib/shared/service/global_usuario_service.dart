import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:realtime_chat/shared/models/user.dart';
import 'package:flutter/material.dart';

class GlobalUsuarioService with ChangeNotifier {
  User? _usuario;

  User? get usuario => _usuario;

  Future<void> guardarUsuario(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = jsonEncode(user.toJson());
    await prefs.setString('usuario', userData);
    _usuario = user;
    notifyListeners();
  }

  Future<void> cargarUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('usuario');
    if (userData != null) {
      _usuario = User.fromJson(jsonDecode(userData));
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
