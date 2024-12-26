import 'package:go_router/go_router.dart';
import 'package:realtime_chat/apps/auth/auth_routes.dart';
import 'package:realtime_chat/apps/home/home_routes.dart';
import 'package:realtime_chat/apps/auth/presentation/splash_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashPage(), 
      ),
      ...AuthRoutes.authRoutes, 
      ...HomeRoutes.homeRoutes, 
    ],
  );
}
