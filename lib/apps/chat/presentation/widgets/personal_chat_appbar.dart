import 'package:flutter/material.dart';
import 'package:realtime_chat/shared/models/user.dart';

class PersonalChatAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  final User user;

  const PersonalChatAppbar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.red,
      iconTheme: const IconThemeData(color: Colors.white),
      elevation: 1,
      title: Row(
        children: [
          const Icon(Icons.account_circle, color: Colors.white, size: 42),
          const SizedBox(width: 3),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.name,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Icon(Icons.circle,
                      color: user.online ? Colors.green : Colors.grey,
                      size: 16),
                  const SizedBox(width: 3),
                  Text(user.online ? 'En línea' : 'Desconectado',
                      style: const TextStyle(color: Colors.white, fontSize: 12))
                ],
              )
            ],
          ),
          const Spacer(),
          const Icon(Icons.settings, color: Colors.white, size: 24),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
