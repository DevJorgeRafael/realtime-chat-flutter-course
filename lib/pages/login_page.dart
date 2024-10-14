import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 228, 228, 228),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            _Logo(),

            _Form(),

            _Labels(),

            const Text('Términos y condiciones de uso', style: TextStyle( fontWeight: FontWeight.w200 ))
            
          ],
        ),
      )
    );
  }
}


class _Logo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 50),
        width: 170,
        child: const Column(
          children: [

            Image(image: AssetImage('assets/logo-UTN.png')),
            SizedBox( height: 20, ),
            Text('Red Social UTN', style: TextStyle(fontSize: 25),)

          ],
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {

  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          TextField(),
          TextField(),

          ElevatedButton(
            onPressed: () { }, 
            child: Text('Ingresar'),
          )
        ],
      ),
    );
  }
}

class _Labels extends StatelessWidget {
  const _Labels({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const Text('¿No tienes cuenta?', style: TextStyle( color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w300 ),),
          SizedBox( height: 10, ),
          Text('Crear una cuenta', style: TextStyle( color: Colors.red[600], fontSize: 18, fontWeight: FontWeight.bold ),),
        ],
      )
    );
  }
}