import 'package:flutter/material.dart';
import 'package:realtime_chat/apps/auth/presentation/login_page.dart';
import 'package:realtime_chat/apps/auth/presentation/register_page.dart';
import 'package:realtime_chat/helpers/navigation_helper.dart';

class Labels extends StatelessWidget {
  final String routePath;
  final String title;
  final String subtitle;

  const Labels({
    super.key,
    required this.routePath,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          subtitle,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 15,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () {
            if (routePath == 'login') {
              NavigationHelper.navigateWithAnimation(
                context,
                const LoginPage(),
                direction: NavigationDirection.left,
              );
            } else if (routePath == 'register') {
              NavigationHelper.navigateWithAnimation(
                context,
                const RegisterPage(),
                direction: NavigationDirection.right,
              );
            }
          },
          child: Text(
            title,
            style: TextStyle(
              color: Colors.red[600],
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
