import 'package:flutter/material.dart';

enum NavigationDirection { left, right }

class NavigationHelper {
  static void navigateWithAnimation(
    BuildContext context,
    Widget page, {
      NavigationDirection direction = NavigationDirection.right,
    
  }) {
    Navigator.push(
      context, 
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const curve = Curves.easeInOut;

          Offset begin = direction == NavigationDirection.right
            ? const Offset(1.0, 0.0)
            : const Offset(-1.0, 0.0);
          const Offset end = Offset.zero;

          final tween = Tween(begin: begin, end: end)
            .chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),

        )
      );
  }
}