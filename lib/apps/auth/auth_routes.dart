import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:realtime_chat/apps/auth/presentation/splash_page.dart';
import 'package:realtime_chat/apps/auth/presentation/login_page.dart';
import 'package:realtime_chat/apps/auth/presentation/register_page.dart';

class AuthRoutes {
  static final authRoutes = [
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) {
        return _slidePage(
          key: state.pageKey,
          child: const LoginPage(),
          beginOffset: const Offset(1.0, 0.0), // De derecha a izquierda
        );
      },
    ),
    GoRoute(
      path: '/register',
      pageBuilder: (context, state) {
        return _slidePage(
          key: state.pageKey,
          child: const RegisterPage(),
          beginOffset: const Offset(-1.0, 0.0), // De izquierda a derecha
        );
      },
    ),
    GoRoute(
      path: '/',
      pageBuilder: (context, state) {
        return _slidePage(
          key: state.pageKey,
          child: const SplashPage(),
          beginOffset: const Offset(0.0, -1.0), // Desde arriba
        );
      },
    ),
  ];

  static CustomTransitionPage _slidePage({
    required Widget child,
    required LocalKey key,
    required Offset beginOffset,
  }) {
    return CustomTransitionPage(
      key: key,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(begin: beginOffset, end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeInOut));
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}
