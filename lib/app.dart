import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'package:realtime_chat/apps/auth/domain/auth_service.dart';
import 'package:realtime_chat/apps/home/domain/socket_service.dart';
import 'package:realtime_chat/config/routes/app_router.dart';
import 'package:realtime_chat/config/theme/app_theme.dart';
import 'package:realtime_chat/injection_container.dart';
import 'package:realtime_chat/shared/service/dio_client.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AppTheme appTheme = sl<AppTheme>();

    DioClient.setupInterceptors();
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => sl<AuthService>()),
        ChangeNotifierProvider(create: (_) => sl<SocketService>()),

      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Red Social UTN',
        theme: appTheme.getTheme(),
        routerConfig: AppRouter.router,

        // Configuración de localización
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('es', 'ES'), // Español
          // Agrega otros locales si es necesario
        ],
        locale: const Locale('es', 'ES'), // Idioma predeterminado
      ),
    );
  }
}