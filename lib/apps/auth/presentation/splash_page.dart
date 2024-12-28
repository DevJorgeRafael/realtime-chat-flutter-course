import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:realtime_chat/apps/auth/domain/auth_service.dart';
import 'package:realtime_chat/injection_container.dart';
import 'package:realtime_chat/shared/service/global_usuario_service.dart';
import 'package:realtime_chat/apps/home/domain/socket_service.dart';
import 'package:realtime_chat/shared/widgets/logo.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Realizamos las verificaciones iniciales después de construir el widget.
      await _checkLoginState(context);
    });

    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Red Social UTN',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Logo()
          ]
        ),
      ),
    );
  }

  Future<void> _checkLoginState(BuildContext context) async {
    final authService = sl<AuthService>();
    final socketService = sl<SocketService>();
    final globalUsuarioService = sl<GlobalUsuarioService>();

    // Cargar datos del usuario global
    await globalUsuarioService.cargarUsuario();
    final token = await AuthService.getToken();

    // Verificar si el usuario ya está autenticado
    if (globalUsuarioService.usuario != null && token.isNotEmpty) {
      authService.user = globalUsuarioService.usuario!;
      socketService.connect();

      if (context.mounted) {
        context.go('/home'); // Redirigir a la página principal
      }
    } else {
      // Verificar si el token es válido o el usuario necesita iniciar sesión
      final bool autenticado = await authService.isLoggedIn(context);

      if (!context.mounted) return;

      if (autenticado) {
        context.go('/home');
      } else {
        context.go('/login');
      }
    }
  }
}
