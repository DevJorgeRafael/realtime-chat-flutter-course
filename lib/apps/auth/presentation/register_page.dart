import 'package:flutter/material.dart';
import 'package:realtime_chat/apps/auth/domain/auth_service.dart';
import 'package:go_router/go_router.dart';
import 'package:realtime_chat/apps/auth/widgets/boton_ingresar_rojo.dart';
import 'package:realtime_chat/apps/auth/widgets/custom_input.dart';
import 'package:realtime_chat/apps/auth/widgets/labels.dart';

import 'package:realtime_chat/apps/home/domain/socket_service.dart';
import 'package:realtime_chat/helpers/mostrar_alerta.dart';
import 'package:realtime_chat/injection_container.dart';
import 'package:realtime_chat/widgets/logo.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 240, 240, 240),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Logo(),

                  _Form(),

                  const Labels(ruta: 'login', titulo: 'Ingresa con tu cuenta', subtitulo: '¿Ya tienes una cuenta?',),
                  const Text('Términos y condiciones de uso',
                      style: TextStyle(fontWeight: FontWeight.w200))
                ],
              ),
            ),
          ),
        ));
  }
}

class _Form extends StatefulWidget {
  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = sl<AuthService>();
    final socketService = sl<SocketService>();

    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.perm_identity,
            placeholder: 'Nombre',
            keyboardType: TextInputType.emailAddress,
            textController: nameCtrl,
          ),
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
          BotonIngresarRojo(
            text: 'Registrarse',
            onPressed: authService.autenticando ? null : () async {
              final registerError = await authService.register(nameCtrl.text.trim(), emailCtrl.text.trim(), passCtrl.text.trim());

              if ( registerError == null ) {
                socketService.connect();
                context.go('/home');
              } else {
                mostrarAlerta(context, 'Error en el registro', registerError);
              }
            },
          ),
        ],
      ),
    );
  }
}
