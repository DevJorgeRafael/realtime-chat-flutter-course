import 'package:flutter/material.dart';
import 'package:realtime_chat/injection_container.dart';
import 'package:realtime_chat/config/routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Real Time Chat',
      routerConfig: AppRouter.router,
    );
  }
}