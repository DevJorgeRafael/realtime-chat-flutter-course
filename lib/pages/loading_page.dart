import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:realtime_chat/services/services.dart';

import 'package:realtime_chat/pages/login_page.dart';
import 'package:realtime_chat/pages/usuarios_page.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        builder: (context, snapshot) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        future: checkLoginState( context ),
        
      ),
    );
  }

  Future checkLoginState( BuildContext context ) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context, listen: false);
    final globalUsuarioService = Provider.of<GlobalUsuarioService>(context, listen: false);

    await globalUsuarioService.cargarUsuario();
    final token = await AuthService.getToken();

    if( globalUsuarioService.usuario != null && token.isNotEmpty ) {
      authService.usuario = globalUsuarioService.usuario!;
      socketService.connect();
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context, 
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const UsuariosPage(),
          transitionDuration: const Duration(milliseconds: 1000)
        )
      );
    } else {
      final bool autenticado = await authService.isLoggedIn(context);

      if (!context.mounted ) return;
      if (autenticado) {
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                pageBuilder: (_, __, ___) => const UsuariosPage(),
                transitionDuration: const Duration(milliseconds: 1000)));
      } else {
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                pageBuilder: (_, __, ___) => const LoginPage(),
                transitionDuration: const Duration(milliseconds: 1000)));
      }
    }
  }
}
