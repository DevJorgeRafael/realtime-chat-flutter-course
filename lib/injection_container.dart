import 'package:get_it/get_it.dart';
import 'package:realtime_chat/apps/auth/domain/auth_service.dart';
import 'package:realtime_chat/apps/home/domain/chat_service.dart';
import 'package:realtime_chat/apps/home/domain/socket_service.dart';
import 'package:realtime_chat/apps/home/domain/users_service.dart';
import 'package:realtime_chat/shared/service/global_usuario_service.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Register the services
  sl.registerLazySingleton<AuthService>(() => AuthService());
  sl.registerLazySingleton<ChatService>(() => ChatService());
  sl.registerLazySingleton<SocketService>(() => SocketService());
  sl.registerLazySingleton<UsersService>(() => UsersService());
  sl.registerLazySingleton<GlobalUsuarioService>(() => GlobalUsuarioService()..cargarUsuario());
}