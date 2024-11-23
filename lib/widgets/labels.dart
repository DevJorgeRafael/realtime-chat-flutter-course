import 'package:flutter/material.dart';
import 'package:realtime_chat/pages/login_page.dart';
import 'package:realtime_chat/pages/register_page.dart';

class Labels extends StatelessWidget {
  final String ruta;

  final String titulo;
  final String subtitulo;

  const Labels({
    super.key, 
    required this.ruta, 
    required this.titulo, 
    required this.subtitulo
  });

  @override
  Widget build(BuildContext context) {
    return Column(
    children: [
      Text(
        subtitulo,
        style: const TextStyle(
            color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w300),
      ),
      const SizedBox(
        height: 10,
      ),
      GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  // Definir la página a la que quieres navegar
                  if (ruta == 'login') {
                    return const LoginPage(); // Reemplaza con tu página de login
                  } else if (ruta == 'register') {
                    return const RegisterPage(); // Reemplaza con tu página de registro
                  }
                  return Container(); // Página por defecto en caso de no coincidir
                },
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  var begin = ruta == 'login'
                      ? const Offset(-1.0, 0.0) // Desliza desde la izquierda
                      : const Offset(1.0, 0.0); // Desliza desde la derecha

                  var end = Offset.zero;
                  var curve = Curves.easeInOut;

                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);

                  return SlideTransition(
                      position: offsetAnimation, child: child);
                },
                transitionDuration: const Duration(milliseconds: 300),
              ),
            );
          },
          child: Text(
            titulo,
            style: TextStyle(
              color: Colors.red[600],
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
    ],
        );
  }
}
