import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:realtime_chat/app.dart';
import 'package:realtime_chat/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Forzar la orientación vertical
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  await setupServiceLocator();
  runApp(const MyApp());
}