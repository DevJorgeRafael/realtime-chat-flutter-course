import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:realtime_chat/apps/auth/domain/auth_service.dart';
import 'package:realtime_chat/apps/auth/widgets/boton_ingresar_rojo.dart';
import 'package:realtime_chat/apps/auth/widgets/labels.dart';
import 'package:realtime_chat/helpers/mostrar_alerta.dart';
import 'package:realtime_chat/apps/chat/domain/socket_service.dart';
import 'package:realtime_chat/injection_container.dart';
import 'package:realtime_chat/shared/widgets/logo.dart';
import 'package:realtime_chat/apps/auth/widgets/custom_input.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
            
                const Labels(routePath: 'register', title: 'Crear una cuenta', subtitle: '¿No tienes cuenta?',),
            
                const Text('Términos y condiciones de uso', style: TextStyle( fontWeight: FontWeight.w200 ))
                
              ],
            ),
          ),
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
    final authService = sl<AuthService>();
    final socketService = sl<SocketService>();

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
          

          BotonIngresarRojo(
            text: 'Ingresar', 
            onPressed: authService.authenticating? null : () async {

              FocusScope.of( context ).unfocus();

              final loginRestult = await authService.login(emailCtrl.text.trim(), passCtrl.text.trim());

              if( loginRestult['ok'] == 'true' ) {
                socketService.connect();
                context.go('/home');
              } else {
                mostrarAlerta(context, 'Error de autenticación', loginRestult['message']);
              }
          }),
        ],
      ),
    );
  }
}

