import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final IconData icon;
  final String placeholder;
  final TextEditingController textController;
  final TextInputType keyboardType;
  final bool isPassword;
  final String? errorMessage; // Mensaje de error opcional

  const CustomInput({
    required this.icon,
    required this.placeholder,
    required this.textController,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.errorMessage, // Pasar null si no hay error
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorMessage != null && errorMessage!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 20),
          margin: EdgeInsets.only(bottom: errorMessage != null ? 5 : 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, 5),
                blurRadius: 5,
              ),
            ],
            border: hasError
                ? Border.all(color: Colors.red, width: 1.5)
                : null, // Borde rojo si hay error
          ),
          child: TextField(
            controller: textController,
            autocorrect: false,
            keyboardType: keyboardType,
            obscureText: isPassword,
            decoration: InputDecoration(
              prefixIcon: Icon(icon),
              focusedBorder: InputBorder.none,
              border: InputBorder.none,
              hintText: placeholder,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        if (hasError) // Mostrar el mensaje de error solo si existe
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
