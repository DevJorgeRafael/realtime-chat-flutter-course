import 'package:go_router/go_router.dart';
import 'package:realtime_chat/apps/auth/presentation/splash_page.dart';
import 'package:realtime_chat/apps/auth/presentation/login_page.dart';
import 'package:realtime_chat/apps/auth/presentation/register_page.dart';

class AuthRoutes {
  static final authRoutes = [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashPage(),
    ),
  ];
}
