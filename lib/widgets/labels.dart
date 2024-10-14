import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  const Labels({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
      children: [
        const Text(
          '¿No tienes cuenta?',
          style: TextStyle(
              color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w300),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'Crear una cuenta',
          style: TextStyle(
              color: Colors.red[600],
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
      ],
    ));
  }
}
