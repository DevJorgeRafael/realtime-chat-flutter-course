import 'package:flutter/material.dart';

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
    return Container(
      child: Column(
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
            Navigator.pushReplacementNamed(context, ruta);
          },
          child: Text(
            titulo,
            style: TextStyle(
                color: Colors.red[600],
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ));
  }
}
