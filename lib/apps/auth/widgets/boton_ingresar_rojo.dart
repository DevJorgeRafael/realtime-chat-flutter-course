import 'package:flutter/material.dart';

class BotonIngresarRojo extends StatelessWidget {

  final String text;
  final VoidCallback? onPressed;

  const BotonIngresarRojo({
    super.key, 
    required this.text, 
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        shape: const StadiumBorder(),
        backgroundColor: Colors.red
      ),
      onPressed: onPressed, 
      child: Container(
        width: double.infinity,
        height: 55,
        child: Center(
          child: Text(text, style: TextStyle( color: Colors.white, fontSize: 17 ),)
        ),
        
      ),
    );
  }
}