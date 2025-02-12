import 'package:get_it/get_it.dart';
import 'package:realtime_chat/apps/auth/domain/auth_service.dart';
import 'package:realtime_chat/apps/chat/domain/chat_service.dart';
import 'package:realtime_chat/apps/chat/domain/socket_service.dart';
import 'package:realtime_chat/apps/chat/domain/users_service.dart';
import 'package:realtime_chat/config/theme/app_theme.dart';
import 'package:realtime_chat/shared/service/global_usuario_service.dart';


final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // ---------------------Dependencias Globales---------------------
  // sl.registerSinfleton<Dio>
  sl.registerSingleton<AppTheme>(AppTheme());

  // --------------------- Dependencias la App---------------------
  sl.registerLazySingleton<AuthService>(() => AuthService());
  sl.registerLazySingleton<ChatService>(() => ChatService());
  sl.registerLazySingleton<SocketService>(() => SocketService());
  sl.registerLazySingleton<UsersService>(() => UsersService());
  sl.registerLazySingleton<GlobalUsuarioService>(() => GlobalUsuarioService()..cargarUsuario());
}