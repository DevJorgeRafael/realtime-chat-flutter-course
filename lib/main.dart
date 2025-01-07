import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:realtime_chat/app.dart';
import 'package:realtime_chat/injection_container.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();

  // Forzar la orientación vertical
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown 
  ]);

  await setupServiceLocator();
  runApp(const MyApp());
}