import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:realtime_chat/routes/routes.dart';
import 'package:realtime_chat/services/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ( _ ) => AuthService() ),
        ChangeNotifierProvider(create: ( _ ) => SocketService() ),
        ChangeNotifierProvider(create: ( _ ) => ChatService() ),
        ChangeNotifierProvider(create: ( _ ) => GlobalUsuarioService()..cargarUsuario() ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat App',
        initialRoute: 'loading',
        routes: appRoutes,
      ),
    );
  }
}