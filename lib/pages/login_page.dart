import 'package:flutter/material.dart';
import 'package:realtime_chat/widgets/widgets.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Logo(),

            _Form(),

            const Labels(),

            const Text('Términos y condiciones de uso', style: TextStyle( fontWeight: FontWeight.w200 ))
            
          ],
        ),
      )
    );
  }
}


class _Form extends StatefulWidget {

  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {

  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),

      child: Column(
        children: [
          
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Correo Electrónico',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Contraseña',
            textController: passCtrl,
            isPassword: true,
          ),
          


          //TODO: crear botón
          BotonIngresarRojo(text: 'Ingresar', onPressed: () {
            print(emailCtrl.text);
            print(passCtrl.text);
          },),
        ],
      ),
    );
  }
}

