import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
            if ( ruta == 'login' ) {
              context.go('/login');
            } else if ( ruta == 'register' ) {
              context.go('/register');
            }
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
